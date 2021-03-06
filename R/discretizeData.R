#' Discretizes input data into two levels.
#'
#' Discretizes input data into the following two levels:
#' Less than wild type => level 1
#' Greater than equal to wild type => level 2
#'
#' @param input.data the data that is given as the input, data frame to be discretized
#' @param input.wt.data.filename path of the file containing the table
#'
#' @return input data discretized into 2 levels
#'
#' @keywords internal
#' @noRd
discretizeData.2L.wt.l <- function(input.data, input.wt.data.filename) {
  if(!base::is.data.frame(input.data))
  {
    base::stop("Error in discretizeData.2L.wt.l input.data is not a data frame")
  }
  input.wt.data <- utils::read.table(input.wt.data.filename, header = TRUE, sep="\t")

  wt.data <- input.wt.data[1, -1]
  # wt.data[i] contains the wild type expression value of the i^{th} gene

  input.data.discr <- input.data
  # input.data.discr[,] <- 0

  for (colIdx in 1:ncol(input.data))
  {
    for (rowIdx in 1:nrow(input.data))
    {
      if (input.data.discr[rowIdx, colIdx] < wt.data[colIdx])
      {
        input.data.discr[rowIdx, colIdx] <- 1
      }
      else if (input.data.discr[rowIdx, colIdx] >= wt.data[colIdx])
      {
        input.data.discr[rowIdx, colIdx] <- 2
      }
    }
  }

  return(input.data.discr)
}

#' Discretizes input data into two levels.
#'
#' Discretizes input data into the following two levels:
#' Less than wild type => level 1
#' Greater than equal to wild type => level 2
#'
#' @param input.data the data that is given as the input, data frame to be discretized
#' @param input.wt.data.filename path of the file containing the table
#'
#' @return input data discretized into 2 levels
#'
#' @keywords internal
#' @noRd
discretizeData.2L.wt.le <- function(input.data, input.wt.data.filename) {
  if(!base::is.data.frame(input.data))
  {
    base::stop("Error in discretizeData.2L.wt.le input.data is not a matrix")
  }
  input.wt.data <- utils::read.table(input.wt.data.filename, header = TRUE, sep="\t")

  wt.data <- input.wt.data[1, -1]
  # wt.data[i] contains the wild type expression value of the i^{th} gene

  input.data.discr <- input.data
  # input.data.discr[,] <- 0

  for (colIdx in 1:ncol(input.data))
  {
    for (rowIdx in 1:nrow(input.data))
    {
      if (input.data.discr[rowIdx, colIdx] <= wt.data[colIdx])
      {
        input.data.discr[rowIdx, colIdx] <- 1
      }
      else if (input.data.discr[rowIdx, colIdx] >= wt.data[colIdx])
      {
        input.data.discr[rowIdx, colIdx] <- 2
      }
    }
  }

  return(input.data.discr)
}

#' Discretizes input data into three levels, given a tolerance.
#'
#' Discretizes input data into three levels, given a tolerance.
#' Let, expression value of gene i in a particular sample is x_i and
#' wild type expression value of i is wt(i).
#' Level 1: 0 =< x_i < (wt(i) - tolerance). Gene i is down regulated or knocked out.
#' Level 2: (wt(i) - tolerance) =< x_i =< (wt(i) + tolerance). Expression of gene i is at a steady-state.
#' Level 3: (wt(i) + tolerance) < x_i =< 1. Gene i is up regulated.
#'
#' @param input.data the data that is given as the input, data frame to be discretized
#' @param input.wt.data.filename path of the file containing the table
#' @param tolerance the tolerance
#' @param num.discr.levels number of discrete levels
#'
#' @return input data discretized into 3 levels
#'
#' @keywords internal
#' @noRd
discretizeData.3L.wt <- function(input.data, input.wt.data.filename, tolerance, num.discr.levels) {
  if(!base::is.data.frame(input.data))
  {
    base::stop("Error in discretizeData.3L.wt input.data is not a matrix")
  }
  input.wt.data <- utils::read.table(input.wt.data.filename, header = TRUE, sep="\t")

  wt.data <- input.wt.data[1, -1]
  # wt.data[i] contains the wild type expression value of the i^{th} gene

  input.data.discr <- input.data
  # input.data.discr[,] <- 0

  for (colIdx in 1:ncol(input.data))
  {
    for (rowIdx in 1:nrow(input.data))
    {
      if ((0 <= input.data.discr[rowIdx, colIdx]) &&
          (input.data.discr[rowIdx, colIdx] < (wt.data[colIdx] - tolerance)))
      {
        input.data.discr[rowIdx, colIdx] <- 1 # Level 1

      } else if (((wt.data[colIdx] - tolerance) <= input.data.discr[rowIdx, colIdx]) &&
                 (input.data.discr[rowIdx, colIdx] <= (wt.data[colIdx] + tolerance)))
      {
        input.data.discr[rowIdx, colIdx] <- 2 # Level 2

      } else if (((wt.data[colIdx] + tolerance) < input.data.discr[rowIdx, colIdx]) &&
                 (input.data.discr[rowIdx, colIdx] <= 1))
      {
        input.data.discr[rowIdx, colIdx] <- 3 # Level 3

      }
    }
  }

  ## bnstruct::BNDataset() requires the discrete levels of a node to be in order starting from level 1.
  ## Each level index must be in [1, number of discrete levels of that node].
  nodes.discr.sizes <- c()
  for (node.idx in 1:ncol(input.data.discr))
  {
    if (base::length(base::unique(input.data.discr[, node.idx])) > 0)
    {
      discr.levels <- base::sort(base::unique(input.data.discr[, node.idx]))

      for (discr.level.idx in 1:length(discr.levels))
      {
        input.data.discr[input.data.discr[, node.idx] == discr.levels[discr.level.idx], node.idx] <- discr.level.idx
      }

      node.discr.size <- base::length(discr.levels)
      nodes.discr.sizes <- base::c(nodes.discr.sizes, node.discr.size)
    }
  }

  return(base::list(input.data.discr, nodes.discr.sizes))
}

#' Discretizes input data into five levels.
#'
#' Discretizes input data into the following five levels:
#' Let, expression value of gene i in a particular sample is x_i and
#' wild type expression value of i is wt(i).
#' Level 1: x_i = 0. Gene i is knocked out.
#' Level 2: 0 < x_i < wt(i). Gene i is down regulated but not knocked out.
#' Level 3: x_i = wt(i). Expression of gene i is at a steady-state.
#' Level 4: wt(i) < x_i < 1. Gene i is up regulated but not maximally activated.
#' Level 5: x_i = 1. Gene i is maximally activated.
#'
#' @param input.data the data that is given as the input, data frame to be discretized
#' @param input.wt.data.filename path of the file containing the table
#' @param num.discr.levels number of discrete levels
#'
#' @return input data discretized into 5 levels
#'
#' @keywords internal
#' @noRd
discretizeData.5L.wt <- function(input.data, input.wt.data.filename, num.discr.levels) {
  if(!base::is.data.frame(input.data))
  {
    base::stop("Error in discretizeData.5L.wt input.data is not a matrix")
  }
  input.wt.data <- utils::read.table(input.wt.data.filename, header = TRUE, sep="\t")

  wt.data <- input.wt.data[1, -1]
  # wt.data[i] contains the wild type expression value of the i^{th} gene

  input.data.discr <- input.data
  # input.data.discr[,] <- 0

  for (colIdx in 1:ncol(input.data))
  {
    for (rowIdx in 1:nrow(input.data))
    {
      if (input.data.discr[rowIdx, colIdx] == 0)
      {
        input.data.discr[rowIdx, colIdx] <- 1 # Level 1

      } else if ((input.data.discr[rowIdx, colIdx] > 0) && (input.data.discr[rowIdx, colIdx] < wt.data[colIdx]))
      {
        input.data.discr[rowIdx, colIdx] <- 2 # Level 2

      } else if (input.data.discr[rowIdx, colIdx] == wt.data[colIdx])
      {
        input.data.discr[rowIdx, colIdx] <- 3 # Level 3

      } else if ((input.data.discr[rowIdx, colIdx] > wt.data[colIdx]) && (input.data.discr[rowIdx, colIdx] < 1))
      {
        input.data.discr[rowIdx, colIdx] <- 4 # Level 4

      } else if (input.data.discr[rowIdx, colIdx] == 1)
      {
        input.data.discr[rowIdx, colIdx] <- 5 # Level 5

      }
    }
  }

  ## bnstruct::BNDataset() requires the discrete levels of a node to be in order starting from level 1.
  ## Each level index must be in [1, number of discrete levels of that node].
  for (node.idx in 1:ncol(input.data.discr))
  {
    if ((base::length(base::unique(input.data.discr[, node.idx])) > 0) &&
        (base::length(base::unique(input.data.discr[, node.idx])) != num.discr.levels))
    {
      discr.levels <- base::sort(base::unique(input.data.discr[, node.idx]))

      for (discr.level.idx in 1:length(discr.levels))
      {
        input.data.discr[input.data.discr[, node.idx] == discr.levels[discr.level.idx], node.idx] <- discr.level.idx
      }
    }
  }

  return(input.data.discr)
}

#' Discretize input data into 2 levels.
#'
#' Discretize input data into the following two levels as done in
#' For each gene, the expression values are first sorted; then the top 2
#' extreme values in either end of the sorted list are discarded; last,
#' the median of the remaining values is used as the threshold above
#' which the value is binarized as 'Level 2' and 'Level 1' otherwise. Here, 2 means
#' the expression of a gene is up-regulated, and 1 means down-regulated.
#'
#' @param input.data data frame to be discretized. rows have samples and cols have variables.
#'
#' @return data discretized into 2 levels
#'
#' @references
#' 1. Ahmed, Amr, and Eric P. Xing. "Recovering time-varying networks of dependencies in social and biological studies."
#' Proceedings of the National Academy of Sciences 106.29 (2009): 11878-11883.]
#'
#' @keywords internal
#' @noRd
discretizeData.2L.Tesla <- function(input.data) {
  if(!base::is.data.frame(input.data))
  {
    base::stop("Error in discretizeData.2L.Tesla input.data is not a matrix")
  }
  ## For each variable
  for (var.idx in 1:ncol(input.data))
  {
    ## Sorted in asc order
    conts.vals.sorted <- sort(input.data[, var.idx])

    if (length(conts.vals.sorted) > 4)
    {
      ## Discard lowest two values
      conts.vals.sorted <- conts.vals.sorted[3:length(conts.vals.sorted)]

      ## Discard highest two values
      conts.vals.sorted <- conts.vals.sorted[1:(length(conts.vals.sorted) - 2)]
    }

    ## Compute median
    discr.threshold <- stats::median(conts.vals.sorted)

    ## For each sample value of the current variable
    for (sample.idx in 1:nrow(input.data))
    {
      if (input.data[sample.idx, var.idx] > discr.threshold)
      {
        input.data[sample.idx, var.idx] <- 2
      }
      else
      {
        input.data[sample.idx, var.idx] <- 1
      }
    }
  }

  return(input.data)
}
