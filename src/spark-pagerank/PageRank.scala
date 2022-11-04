import org.apache.spark.graphx.GraphLoader
import org.apache.spark.graphx.lib.PageRank
import org.apache.spark.sql.SparkSession
import java.io.FileWriter

/**
 * A PageRank benchmark on an edgelist text file.
 * Run with:
 * spark-submit class=BenchPageRank /path/to/jar.jar \
 * </path/to/inputfile.txt> \
 * </path/to/outputfile.txt> \ 
 * [numIterations] \
 * 
 * Runs until convergence if numIterations is not specified.
 */
object RunPageRank {
  def main(args: Array[String]): Unit = {
    //Parse arguments
    var inputFile = ""
    var outputFile = ""
    var numIterations = 0
    if (args.length < 2) {
      System.err.println("Usage: spark-submit class=BenchPageRank /path/to/jar.jar </path/to/inputfile.txt> </path/to/outputfile.txt> [numIterations]")
      System.exit(-1)
    } else {
      inputFile = args(0)
      outputFile = args(1)
    }
    if (args.length > 2) {
      numIterations = args(2).toInt
    }

    // Creates a SparkSession.
    val spark = SparkSession
      .builder
      .appName(s"${this.getClass.getSimpleName}")
      .getOrCreate()
    val sc = spark.sparkContext

    // Load the edges as a graph
    val graph = GraphLoader.edgeListFile(sc, inputFile)

    var start:Long = 0
    var execTime:Long = 0
    println("Running PageRank for " + numIterations + " iterations...\n")
    if (numIterations == 0) {
      // Run PageRank until convergence
      start = System.currentTimeMillis()
      graph.pageRank(0.0001).vertices
      execTime = (System.currentTimeMillis() - start)
    } else {
      // Run Pagerank for set number of iterations
      start = System.currentTimeMillis()
      PageRank.run(graph, numIterations)
      execTime = (System.currentTimeMillis() - start)
    }

    // Print the result and append time to file
    val fw = new FileWriter(outputFile, true)
    fw.write(execTime.toString() + '\n')
    fw.close()
    spark.stop()
  }
}
// scalastyle:on println
