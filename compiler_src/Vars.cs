using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace compiler
{
    public class Vars
    {
        private String file;

        public Dictionary<String, String> EnVars
        {
            get;
            private set;
        }

        public List<String> Libs
        {
            get;
            private set;
        }

        public String Version
        {
            get;
            private set;
        }

        public String ProjectName
        {
            get;
            private set;
        }

        public Vars(String file)
        {
            this.EnVars = new Dictionary<String, String>();
            this.Libs = new List<String>();
            this.file = file;
        }

        public void process()
        {
            // Gotta create CURDIR first, default, it's needed.
            EnVars.Add("CURDIR", Directory.GetCurrentDirectory() + "\\");

            FileStream file = File.Open(this.file, FileMode.Open);
            StreamReader reader = new StreamReader(file);
            String line = "";
            while((line = reader.ReadLine()) != null)
            {
                processLine(line);
            }
            reader.Close();
            file.Close();

            foreach(string item in EnVars.Keys)
            {
                Console.WriteLine(item + ": " + EnVars[item]);
            }

            Console.WriteLine();
        }

        private void processLine(String line)
        {
            // Simple check for removing headers and comments
            // Header ex: [Header Name]
            if (!Regex.IsMatch(line, @"[\[][a-zA-Z\s]+[\]]") || !line.StartsWith("#") || !line.StartsWith(";"))
            {
                if(line.EndsWith(".dll"))
                {
                    // For adding libraries to List for copying later
                    Libs.Add(line);
                }
                else if(line.Contains("="))
                {
                    // Make sure the trailing slash is there
                    // add if it's not
                    if (!line.EndsWith("\\"))
                    {
                        line = line + "\\";
                    }
                    string[] pieces = Regex.Split(line, @"(?:\s=\s|=)");

                    // Check for macros in INI file
                    String str = parseMacros(pieces[1]);
                    switch (pieces[0])
                    {
                        case "QBIN":
                            EnVars.Add("QBIN", str);
                            break;
                        case "MBIN":
                            EnVars.Add("MBIN", str);
                            break;
                        case "MROOT":
                            EnVars.Add("MROOT", str);
                            break;
                        case "ISS":
                            EnVars.Add("ISS", str);
                            break;
                        case "MKBIN":
                            EnVars.Add("MKBIN", str);
                            break;
                        case "MINGW":
                            EnVars.Add("MINGW", str);
                            // Now, add it to system path, but only for life of process
                            var mingwdir = @"C:\MinGW\bin\";
                            var path = Environment.GetEnvironmentVariable("path");
                            Environment.SetEnvironmentVariable(
                                "path",
                                mingwdir + ";" + path,
                                EnvironmentVariableTarget.Process);
                            break;
                        case "Version":
                            this.Version = str.Split('\\')[0];
                            break;
                        case "Name":
                            this.ProjectName = str.Split('\\')[0];
                            break;
                    }
                }
            }
        }

        private String parseMacros(String str)
        {
            string[] p = Regex.Split(str, "#");
            String macro = "";
            if(p.Length > 1)
            {
                switch(p[1])
                {
                    case "CURDIR":
                        String cd = EnVars["CURDIR"];
                        macro = p[1].Replace("CURDIR", cd.TrimEnd('\\')) + p[2];
                        break;
                    case "PROGRAMFILES32":
                        String pfx = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86);
                        macro = p[1].Replace("PROGRAMFILES32", pfx) + p[2];
                        break;
                    case "PROGRAMFILES":
                        String pf = Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles);
                        macro = p[1].Replace("PROGRAMFILES", pf) + p[2];
                        break;
                    case "PROJECTNAME":
                        macro = p[1].Replace("PROJECTNAME", ProjectName) + p[2];
                        break;
                }
            }
            else
            {
                macro = String.Join("", p);
            }

            return macro;
        }
    }
}
