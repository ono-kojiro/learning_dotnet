using System;

using System.IO;

using Gnu.Getopt;

using System.Text.Json;
using System.Text.Json.Nodes;

namespace MyNameSpace
{
    internal class HelloWorld
    {
        static void Main(String[] args)
        {
            int c;
            int index;
            String output = "";

            LongOpt[] longopts = new LongOpt[] {
                new LongOpt("help", Argument.No, null, 'h'),
                new LongOpt("version", Argument.No, null, 'v'),
                new LongOpt("output", Argument.Required, null, 'o'),
            };

            Getopt g = new Getopt("myprogram", args, "hvo:", longopts);

            while ((c = g.getopt()) != -1)
            {
                switch(c)
                {
                    case 'h':
                        break;
                    case 'v':
                        break;
                    case 'o':
                        output = g.Optarg;
                        break;
                    default:
                        break;
                }
            }

            Console.WriteLine("Hello, world!");

            for(index = g.Optind; index < args.Length; index++){
                Console.WriteLine("read {0}", args[index]);
                StreamReader reader = new StreamReader(args[index]);

                string lines = reader.ReadToEnd();
                Console.WriteLine(lines);

                var options = new JsonSerializerOptions { WriteIndented = true };
                JsonNode data = JsonNode.Parse(lines);
                Console.WriteLine(data.ToJsonString(options));

                reader.Close();
            }
        }
    }
}
