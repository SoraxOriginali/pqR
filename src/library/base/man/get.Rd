% File src/library/base/man/get.Rd
% Part of the R package, http://www.R-project.org
% Copyright 1995-2007 R Core Development Team
% Distributed under GPL 2 or later

\name{get}
\alias{get}
\alias{mget}
\title{Return the Value of a Named Object}
\description{
  Search for an \R object with a given name and return it.
}
\usage{
get(x, pos = -1, envir = as.environment(pos), mode = "any",
    inherits = TRUE)

mget(x, envir, mode = "any",
     ifnotfound = list(function(x)
         stop(paste0("value for '", x, "' not found"),
              call. = FALSE)),
     inherits = FALSE)
}
\arguments{
  \item{x}{a variable name (given as a character string).}
  \item{pos}{where to look for the object (see the details section); if
    omitted, the function will search as if the name of the object
    appeared unquoted in an expression.}
  \item{envir}{an alternative way to specify an environment to look in;
    see the \sQuote{Details} section.}
  \item{mode}{the mode or type of object sought: see the
    \sQuote{Details} section.}
  \item{inherits}{should the enclosing frames of the environment be
    searched?}
  \item{ifnotfound}{A \code{\link{list}} of values to be used if the item is
    not found: it will be coerced to list if necessary.}
}
\details{
  The \code{pos} argument can specify the environment in which to look
  for the object in any of several ways: as an integer (the position in
  the \code{\link{search}} list); as the character string name of an
  element in the search list; or as an \code{\link{environment}}
  (including using \code{\link{sys.frame}} to access the currently active
  function calls).  The \code{envir} argument is an alternative way to
  specify an environment, but is primarily there for back compatibility.

  This function looks to see if the name \code{x} has a value bound to
  it in the specified environment.  If \code{inherits} is \code{TRUE} and
  a value is not found for \code{x} in the specified environment, the
  enclosing frames of the environment are searched until the name \code{x}
  is encountered.  See \code{\link{environment}} and the \sQuote{R
  Language Definition} manual for details about the structure of
  environments and their enclosures.

  \bold{Warning:}
  \code{inherits = TRUE} is the default behaviour for \R but not for S.

  If \code{mode} is specified then only objects of that type are sought.
  The \code{mode} may specify one of the collections \code{"numeric"} and
  \code{"function"} (see \code{\link{mode}}): any member of the
  collection will suffice.

  Using a \code{NULL} environment is equivalent to using the current
  environment.

  For \code{mget} multiple values are returned in a named
  \code{list}.   This is true even if only one value is requested. The
  value in \code{mode} and \code{ifnotfound} can be either the same length
  as the number of requested items or of length 1.  The argument
  \code{ifnotfound} must be a list containing either the value to use if
  the requested item is not found or a function of one argument which
  will be called if the item is not found, with argument the name of
  the item being requested.  The default value for \code{inherits} is
  \code{FALSE}, in contrast to the default behavior for \code{get}.

  \code{mode} here is a mixture of the meanings of \code{\link{typeof}}
  and \code{\link{mode}}:  \code{"function"} covers primitive functions
  and operators, \code{"numeric"}, \code{"integer"}, \code{"real"}
  and \code{"double"} all refer to any numeric type, \code{"symbol"} and
  \code{"name"} are equivalent \emph{but} \code{"language"} must be used.
}
\note{
  The reverse of \code{a <- get(nam)} is \code{\link{assign}(nam, a)}.
}
\value{
  The object found.  (If no object is found an error results.)
}
\references{
  Becker, R. A., Chambers, J. M. and Wilks, A. R. (1988)
  \emph{The New S Language}.
  Wadsworth & Brooks/Cole.
}
\seealso{
  \code{\link{exists}}, \code{\link{assign}}.
}
\examples{
get("\%o\%")

##test mget
e1 <- new.env()
mget(letters, e1, ifnotfound = as.list(LETTERS))
}
\keyword{data}
