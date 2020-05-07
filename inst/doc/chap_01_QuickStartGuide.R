## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval = FALSE------------------------------------------------------------
#  install.packages('TGS')

## ----setup--------------------------------------------------------------------
library(TGS)

## ---- eval = FALSE------------------------------------------------------------
#  ## Assign absolute path to the input directory.
#  input_dir <- '/home/saptarshi/datasets'

## ---- eval = FALSE------------------------------------------------------------
#  ## Assign the name of the desired output directory.
#  ## The output directory will be created automatically.
#  output_dir <- '/home/saptarshi/My_TGS_output'
#  
#  ## Run algorithm 'TGS'.
#  ## It is assumed that your data is continuous.
#  ## In case, your data is discrete, simply
#  ## make the following changes:
#  ## (a) is.discrete = TRUE,
#  ## (b) num.discr.levels = <number of discrete
#  ## levels each gene has>,
#  ## (c) discr.algo = ''.
#  ##
#  TGS::LearnTgs(
#    isfile = 0,
#    json.file = '',
#    input.dirname = input_dir,
#    input.data.filename = 'input_data_10.tsv',
#    num.timepts = 21,
#    true.net.filename = '',
#    input.wt.data.filename = '',
#    is.discrete = FALSE,
#    num.discr.levels = 2,
#    discr.algo = 'discretizeData.2L.Tesla',
#    mi.estimator = 'mi.pca.cmi',
#    apply.aracne = FALSE,
#    clr.algo = 'CLR',
#    max.fanin = 14,
#    allow.self.loop = TRUE,
#    scoring.func = 'BIC',
#    output.dirname = output_dir
#  )

## ---- eval = FALSE------------------------------------------------------------
#  ## Assign the name of the desired output directory.
#  ## The output directory will be created automatically.
#  output_dir <- '/home/saptarshi/My_TGS_plus_output'
#  
#  ## Run algorithm 'TGS'
#  TGS::LearnTgs(
#    isfile = 0,
#    json.file = '',
#    input.dirname = input_dir,
#    input.data.filename = 'input_data_10.tsv',
#    num.timepts = 21,
#    true.net.filename = '',
#    input.wt.data.filename = '',
#    is.discrete = FALSE,
#    num.discr.levels = 2,
#    discr.algo = 'discretizeData.2L.Tesla',
#    mi.estimator = 'mi.pca.cmi',
#    apply.aracne = TRUE,
#    clr.algo = 'CLR',
#    max.fanin = 14,
#    allow.self.loop = TRUE,
#    scoring.func = 'BIC',
#    output.dirname = output_dir
#  )

## ---- eval = FALSE------------------------------------------------------------
#  ## Loads a list named 'unrolled.DBN.adj.matrix.list'
#  load('unrolled.DBN.adj.matrix.list.RData')

## ---- eval = FALSE------------------------------------------------------------
#  print(unrolled.DBN.adj.matrix.list[[7]])

