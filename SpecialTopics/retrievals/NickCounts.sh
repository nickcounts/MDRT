#!/bin/zsh

OUTFILE=fork_this
PARAM=foo.ret

let counter=0
foreach file in **/*.fd_info
   let counter=${counter}+1
   dir=${file%%.fd_info}
   sed 's/OUTPUTFILE/'${OUTFILE}'.'${counter}'/g' ${PARAM} > ${OUTFILE}.${counter}.ret 
   HistRetrieve -o ${OUTFILE}.${counter} -f $dir ${OUTFILE}.${counter}.ret
end

wc -l ${OUTFILE}.*.delim
