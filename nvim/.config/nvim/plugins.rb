require "yaml"
require "set"
require "fileutils"
require "optparse"
require "minitest"

def add(name:, kind:, sh: false, lockfile:)
  path ="pack/plugins/#{kind}/#{File.basename name}"

  lock = case lockfile[path]
         in [x] then x
         else {}
         end

  old_sha = lock.fetch :sha, false
  old_name = lock.fetch :name, false
  old_source = lock.fetch :source, false
  sha = nil
  source = nil

  if ! File.exists?(path) then
    `git clone https://github.com/#{name} #{path} --depth=1`

    if old_sha
      Dir.chdir(path) { `git reset --hard #{old_sha}` }
    end

    if sh then
      Dir.chdir(path) { system(sh) }
    end
  elsif old_source
    source = Dir.chdir(path) { `git remote get-url origin`.strip! }

    if old_source != source
      throw "#{source} doesn't match locked source: #{old_source}"
    end

  elsif old_sha
    sha = get_sha(path)
    if old_sha != sha
      throw "#{name} doesn't match locked sha"
    end
  end

  sha ||= get_sha(path)

  puts "[X] #{name} (#{sha})"

  {path: path, sha: sha, name: name, source: source}
end

def get_sha(dir)
  `git --git-dir #{__dir__}/#{dir}/.git rev-parse --short HEAD`.strip!
end

def install_kind(modules, kind, lockfile)
  modules.map do |spec|
    case spec
    in Hash
      add(**spec, kind: kind, lockfile: lockfile)
    in String => name
      add(name: name, kind: kind, lockfile: lockfile)
    end
  end
end

def main
  options = {}

  OptionParser.new do
  end.parse!

  config = YAML.load(File.read("./plugins.yaml"), symbolize_names: true)

  packages = config.fetch :packages
  start = packages.fetch :start, {}
  opt = packages.fetch :opt, {}

  lockfile_path = "./plugins.lock.yaml"
  lockfile =
    if File.exists?(lockfile_path) then
      data = YAML.load(File.read(lockfile_path), symbolize_names: true)
      data.fetch(:packages).group_by { |x| x[:path] }
    else
      {}
    end

  locked = ["start", "opt"].map do |kind|
    installed = Set.new(Dir["pack/plugins/#{kind}/*"])

    list = packages.fetch(kind.to_sym, {})

    results = install_kind(list, kind, lockfile)

    listed = results.map do |item|
      item in {sha:, path:}
      path
    end

    listed = Set.new(listed)

    extra = installed - listed

    extra.each do |path|
      path = File.join([".", path])
      FileUtils.rm_rf(path)
      puts "removed: #{path}"
    end

    locked = results.map do |item|
      item in {sha:, name:, path:, source:}
      {"sha" => sha, "name" => name, "path" => path, "source" => source}
    end
  end.flatten()

  File.open(lockfile_path, "w") do |f|
    f.write(YAML.dump({"packages" => locked}, header: true))
  end
end

main
