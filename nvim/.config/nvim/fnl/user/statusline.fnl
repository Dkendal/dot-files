(fn init []
  (let [gl (require :galaxyline) ;
        section gl.section ;; extensions
        diagnostic (require :galaxyline.provider_diagnostic)
        vcs (require :galaxyline.provider_vcs)
        fileinfo (require :galaxyline.provider_fileinfo)
        extension (require :galaxyline.provider_extensions)
        buffer (require :galaxyline.provider_buffer)
        whitespace (require :galaxyline.provider_whitespace)
        lspclient (require :galaxyline.provider_lsp)
        lsp-status (require :lsp-status)
        condition (require :galaxyline.condition)
        colors (. (require :galaxyline.theme) :default) ;
        ;; Buffer
        BufferIcon buffer.get_buffer_type_icon
        BufferNumber buffer.get_buffer_number
        FileTypeName buffer.get_buffer_filetype ;
        ;; Git Provider
        GitBranch vcs.get_git_branch
        ;; support vim-gitgutter vim-signify gitsigns
        DiffAdd vcs.diff_add ;; support vim-gitgutter vim-signify gitsigns
        DiffModified vcs.diff_modified
        ;; support vim-gitgutter vim-signify gitsigns
        DiffRemove vcs.diff_remove ;; File Provider
        LineColumn fileinfo.line_column
        FileFormat fileinfo.get_file_format
        FileEncode fileinfo.get_file_encode
        FileSize fileinfo.get_file_size
        FileIcon fileinfo.get_file_icon
        FileName fileinfo.get_current_file_name
        LinePercent fileinfo.current_line_percent
        ScrollBar extension.scrollbar_instance
        VistaPlugin extension.vista_nearest
        Whitespace whitespace.get_item ;
        ;; Diagnostic Provider
        DiagnosticError diagnostic.get_diagnostic_error
        DiagnosticWarn diagnostic.get_diagnostic_warn
        DiagnosticHint diagnostic.get_diagnostic_hint
        DiagnosticInfo diagnostic.get_diagnostic_info ;
        ;; LSP
        GetLspClient lspclient.get_lsp_client ;
        ;;
        v vim.fn
        api vim.api ;;
        ;;
        ]
    (fn LspStatus []
      (when (-> (vim.lsp.buf_get_clients) (length) (> 0))
        (lsp-status.status)))

    (fn cursor []
      (string.format "%d:%d" (v.line ".") (v.col ".")))

    (fn filepath []
      (-> (v.expand "%") (v.simplify) (string.format "%s")))

    (fn hi-attr [name ?attr]
      (-> name (v.hlID) (v.synIDattr (or ?attr :fg))))

    (fn hi [name]
      (local id (v.hlID name))
      (local mode :gui)
      {:fg (v.synIDattr id :fg mode) :bg (v.synIDattr id :bg mode)})

    (local sep {:pyramid-right ""
                :pyramid-empty-right ""
                :pyramid-left ""
                :pyramid-empty-left ""
                :semi-sphere-right ""
                :semi-sphere-empty-right ""
                :semi-sphere-left ""
                :semi-sphere-empty-left ""
                :tri-up-left ""
                :slash-left ""
                :tri-up-right ""
                :slash-right ""
                :tri-down-left ""
                :tri-down-right ""
                :space " "})
    (local colors {:fg (hi-attr :normal :fg)
                   :bg (hi-attr :normal :bg)
                   :fg0 (hi-attr :GruvboxFg0)
                   :fg1 (hi-attr :GruvboxFg1)
                   :fg2 (hi-attr :GruvboxFg2)
                   :fg3 (hi-attr :GruvboxFg3)
                   :fg4 (hi-attr :GruvboxFg4)
                   :bg0 (hi-attr :GruvboxBg0)
                   :bg1 (hi-attr :GruvboxBg1)
                   :bg2 (hi-attr :GruvboxBg2)
                   :bg3 (hi-attr :GruvboxBg3)
                   :bg4 (hi-attr :GruvboxBg4)
                   :purple (hi-attr :GruvboxPurple :fg)
                   :blue (hi-attr :GruvboxBlue :fg)
                   :normal (hi :normal)
                   :StatusLine (hi :StatusLine)})
    (local group {:fileicon [colors.normal.bg colors.purple]
                  :status :StatusLine})

    (fn theme [group]
      (local color_ [colors.fg3 colors.bg1])
      (vim.tbl_extend :keep group
                      {:highlight color_
                       :separator sep.space
                       :separator_highlight color_}))

    (tset section :left
          [{:FileIcon (theme {:provider FileIcon})}
           {:FilePath (theme {:provider filepath})}
           {:LineColumn (theme {:provider cursor})}
           {:LinePercent (theme {:provider LinePercent})}])
    (tset section :mid [])
    (tset section :right [{:LspStatus (theme {:provider LspStatus})}])))

