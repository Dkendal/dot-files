# Defined in - @ line 1
function rgyml --description alias\ rgyml=fd\ -p\ \'/locales/.\*/en.yml\$\'\ components/shopify_payments/\ -x\ flatyml\ \|\ rg\ \'hk\'
	fd -p '/locales/.*/en.yml$' components/shopify_payments/ -x flatyml | rg 'hk' $argv;
end
