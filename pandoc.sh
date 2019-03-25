# Generate Dawn publication list
#    1) Feed the author queries below into the new ADS and save the 
#       output to BibTex files "cph-raw.bib" and "affil-raw.bib".  That is, 
#       run the "cph" query with just the local authors and get the "affil" 
#       results by setting the intermediate flag OR to NOT.
#   
#    2) Update cph.tex with the summary statistics, using these individual
#       queries and the full author list fore the overall citation statistics
#
#    3) Run this file:
#        # (pip install pandoc)
#        # bash pandoc.sh
#
#    4) Still have to manually turn on as an ordered list and set the 
#       Affiliation publication counter to continue with the earlier list
# 
#    5) Also, the left column of the summary stats needs to be manually set to 
#       right-justified.

### Full author query for new ADS:
#
#     ((author:"capak, peter" OR
#       author:"oesch, p" OR
#       author:"whitaker, k" OR
#       author:"narayanan, d" OR
#       author:"finlator, k" OR
#       author:"lagos, c" OR
#       author:"caputi, k" OR
#      (author:"walter, f" AND aff:"Heidelberg") OR
#       author:"colina, l"
#      ) OR 
#      (author:"brammer, g" OR 
#       author:"toft, s" OR 
#       author:"steinhardt, charles" OR 
#       author:"magdis, georgios" OR
#       author:"greve, thomas" OR
#       author:"fynbo, johan" OR
#       author:"watson, d" OR
#       author:"jakobsen, peter" OR
#       author:"nørgaard-nielsen" OR
#       author:"hornstrup, allan" OR
#       author:"valentino, f" OR
#       author:"ceverino, d" OR
#      (author:"nakajima, kimihiko" AND (aff:"European" OR aff:"Observatory of Japan")) OR
#       author:"bonaventura, n" OR
#       author:"milvang-jensen, b" OR
#       author:"selsing, j" OR
#       (author:"stockmann, m" AND aff:"Bohr") OR
#       (author:"gomez-guijarro, c" AND aff:"Bohr") OR
#       author:"cortzen, i" OR 
#       author:"kokorev, v" OR
#       author:"killi, m" OR
#      (author:"weaver, john" AND (aff:"Andrews" OR aff:"Bohr"))
#       ))
#       pubdate:[2018-03-31 TO 2018-12-31]

# Make Dawn authors BOLD, replace journal keywords and some special characters
for root in cph affil; do

    bibfile="${root}.bib"
    cp "${root}-raw.bib" "${root}.bib"

    perl -pi -e "s/\\\\apjl/ApJL/g" ${bibfile}
    perl -pi -e "s/\\\\apj/ApJ/g" ${bibfile}
    perl -pi -e "s/\\\\aj/AJ/g" ${bibfile}
    perl -pi -e "s/\\\\mnras/MNRAS/g" ${bibfile}
    perl -pi -e "s/\\\\aap/A\\\\&A/g" ${bibfile}
    perl -pi -e "s/\\\\nat/Nature/g" ${bibfile}
    perl -pi -e "s/Publications of the Astronomical Society of the Pacific/PASP/" ${bibfile}
    perl -pi -e "s/Publications of the Astronomical Society of Japan/PASJ/" ${bibfile}
    perl -pi -e "s/Publications of the Astronomical Society of Australia/PASA/" ${bibfile}
    perl -pi -e "s/The Astrophysical Journal Supplement Series/ApJSS/" ${bibfile}
    
    perl -pi -e "s/̃/\\$\\\sim\\$/g" ${bibfile}
    perl -pi -e "s/─/--/g" ${bibfile}
    perl -pi -e "s/≃/\\$\\\simeq\\$/g" ${bibfile}
    perl -pi -e "s/\\\\&lt;/\\$<\\$/g" ${bibfile}
    perl -pi -e "s/\\\\&gt;/\\$>\\$/g" ${bibfile}
    perl -pi -e "s/\\\\&amp;/\\\&/g" ${bibfile}
    perl -pi -e "s/Nargaard/N{\\\\o}rgaard/" ${bibfile}
    
    for name in Brammer Toft Steinhardt Magdis Greve Fynbo Watson Jakobsen "N{\\\\o}rgaard-Nielsen" Hornstrup Valentino Ceverino Nakajima Bonaventura Milvang-Jensen Selsing Stockmann G{\'o}mez-Guijarro Cortzen Kokorev Killi Weaver Capak Oesch Whitaker Narayanan Finlator Lagos Caputi Walter Colina; do
        cp ${bibfile} tmp.bib
        sed "s/{${name}}/{\\\bf ${name}}/g" tmp.bib > ${bibfile}
    done
done

# Feed to pandoc
pandoc -o cph.docx --bibliography=cph.bib cph.tex --csl=./chicago-author-date-MOD.csl 
pandoc -o affil.docx --bibliography=affil.bib affil.tex --csl=./chicago-author-date-MOD.csl 

# Combine to single file
pandoc -s cph.docx affil.docx -o pubs.docx 
