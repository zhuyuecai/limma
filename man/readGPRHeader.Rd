\name{readHeader}
\alias{readGenericHeader}
\alias{readGPRHeader}
\alias{readSMDHeader}
\title{Read Header Information from Microarray Raw Data File}
\description{
Read the header information from a microarray raw data file, as output from an image analysis software program such as GenePix.
These functions are used internally by \code{read.maimages} and are not usually called directly by users.
}
\usage{
readGenericHeader(file, columns, sep="\t")
readGPRHeader(file)
readSMDHeader(file)
}
\arguments{
  \item{file}{character string giving file name. If it does not contain an absolute path, the file name is relative to the current working directory.}
  \item{columns}{character vector specifying data column headings expected to be in file}
  \item{sep}{the character string separating column names}
}
\details{
Raw data files exported by image analysis programs include a number of header lines which contain information about the scanning process.
This function extracts that information and locates the line where the intensity data begins.
\code{readGPRHeader} is for GenePix output and \code{readSMDHeader} is for files from the Stanford Microarray Database (SMD).
\code{readGenericHeader} finds the line in the file on which the data begins by searching for specified column headings. 
}
\value{
A list with components corresponds to lines of header information.
A key component is \code{NHeaderRecords} which gives the number of lines in the file before the intensity data begins.
All other components are character vectors.
}
\references{
See \url{http://www.cryer.co.uk/file-types/a/atf/genepix_file_formats.htm} for GenePix formats.

See \url{http://smd.princeton.edu} for the SMD.
}
\author{Gordon Smyth}
\seealso{\code{\link{read.maimages}}

An overview of LIMMA functions to read data is given in \link{03.ReadingData}.
}
\keyword{IO}
\keyword{file}
\concept{microarray data file}

