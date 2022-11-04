name := "spark-pagerank"
version := "1.0"
scalaVersion := "2.12.17"

val sparkVersion = "3.3.0"
libraryDependencies += "org.apache.spark" %% "spark-graphx" % sparkVersion
libraryDependencies += "org.apache.spark" %% "spark-sql" % sparkVersion