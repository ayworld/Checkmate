using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;

namespace compiler
{
    public class Compiler
    {
        private Dictionary<String, String> EnVars;
        private List<String> Libs;
        private String Version;
        private String ProjectName;
        
        // For log
        FileStream os;
        StreamWriter writer;
        string elapsedTime;
        Stopwatch watch;
        
        public Compiler()
        {
            watch = Stopwatch.StartNew();

            logger();

            getEnVars();
			
			// Gotta run some checks to see if compiler can reach
			// Each tool required.
			if(findTools())
				configure();
			else
				Console.Read();
        }

        private void logger()
        {
            // Delete file if it's there to prevent it
            // from having it stack
            if (File.Exists("compile_log.txt"))
                File.Delete("compile_log.txt");

            try
            {
                os = new FileStream("compile_log.txt", FileMode.OpenOrCreate, FileAccess.Write);
                writer = new StreamWriter(os);

                string msg = "Log file for compiler logging.\n";
                writer.WriteLine(msg);
            }
            catch (Exception e)
            {
                Write("Error attempting to generate log");
                Write(e.Message);
                return;
            }
        }

        private void getEnVars()
        {
            Vars v = new Vars("compiler.ini");
            v.process();

            EnVars = v.EnVars;
            Libs = v.Libs;
            Version = v.Version;
            ProjectName = v.ProjectName;

            Write("Project Name: " + ProjectName);
            Write("Version: " + Version);

            Write("\nBegining compilation of " + ProjectName + "\n");
            Write("Setting up environment for build\n");
        }
		
		private bool findTools()
		{
			// boolean for checking
			bool goodToGo = true;
			bool makeLocal = false;
		
			// check if Qt can be found
			if(!File.Exists(EnVars["QBIN"] + "qmake.exe"))
			{
				Write("Error: Qt cannot be found! Please ensure Qt is"
					+ " installed and you've configured the correct location in compiler.ini.");
				goodToGo = false;
			}
			
			// Check for Inno Setup
			else if(!File.Exists(EnVars["ISS"] + "iscc.exe"))
			{
				Write("Error: Inno Setup cannot be found! Please ensure Inno Setup is"
					+ " installed and you've configured the correct location in compiler.ini.");
				goodToGo = false;
			}
			
			// check if Make is installed
			// if not, check if it's in the current directory
			else if(EnVars.ContainsKey("MKBIN"))
			{
				// MKBIN exists, so make sure it's there
                if (!File.Exists(EnVars["MKBIN"] + "make.exe"))
				{
					makeLocal = true;
				}
			}
			else
			{
				makeLocal = true;
			}
			
			// This is for local check on Make
			if(makeLocal)
			{
				if(!File.Exists(EnVars["CURDIR"] + "make.exe"))
				{
					Write("Error: make cannot be found! Please ensure make is"
						+ " installed and you've configured the correct location in compiler.ini,"
						+ " or you have make in the root directory of the project.");
					goodToGo = false;
				}
			}
			
			return goodToGo;
		}

        // Fix for getting make
        private string getMakeLocation()
        {
            if(EnVars.ContainsKey("MKBIN"))
            {
                if(!File.Exists(EnVars["MKBIN"] + "make.exe"))
                {
                    return EnVars["CURDIR"] + "make.exe";
                }
                else
                {
                    return EnVars["MKBIN"] + "make.exe";
                }
            }
            else
            {
                return EnVars["CURDIR"] + "make.exe";
            }
        }

        private void configure()
        {
            Write("Configuring project for compiling..");
            var process = new Process
            {
                StartInfo = new ProcessStartInfo()
                {
                    FileName = EnVars["QBIN"] + "qmake.exe",
                    Arguments = "" + EnVars["CURDIR"] + "src\\" + ProjectName + ".pro",
                    UseShellExecute = false,
                    RedirectStandardOutput = true
                }
            };

            process.OutputDataReceived += process_OutputDataReceived;
            process.Start();
            process.BeginOutputReadLine();
            process.WaitForExit();
            compile();
        }

        private void compile()
        {
            Write("Compiling project..\n");
            var process = new Process
            {
                StartInfo = new ProcessStartInfo()
                {
                    FileName = getMakeLocation(),
                    UseShellExecute = false,
                    RedirectStandardOutput = true
                }
            };

            process.OutputDataReceived += process_OutputDataReceived;
            process.Start();
            process.BeginOutputReadLine();
            process.WaitForExit();

            Write("Copying exe to destination..\n");
            File.Copy(
                EnVars["CURDIR"] + "release\\" + ProjectName + ".exe",
                EnVars["MBIN"] + ProjectName + ".exe",
                true
            );

            getlibs();
        }

        private void getlibs()
        {
            Write("Obtaining Qt libraries...");
            for(int i = 0; i < Libs.Count; i++)
            {
                if(Libs[i].Contains("\\") || Libs[i].Contains("/"))
                {
                    writer.WriteLine("Copying library: " + Libs[i]);
                    writer.Flush();
                    File.Copy(
                        EnVars["QBIN"] + "..\\plugins\\" + Libs[i],
                        EnVars["MBIN"] + Libs[i],
                        true
                    );
                }
                else
                {
                    writer.WriteLine("Copying library: " + Libs[i]);
                    writer.Flush();
                    File.Copy(
                        EnVars["QBIN"] + Libs[i],
                        EnVars["MBIN"] + Libs[i],
                        true
                    );
                }
            }
            Write("");
            //createInstaller();
            copyUpdate();
        }

        private void copyUpdate()
        {
            Write("Copyting new executable to update directory for applicaiton update..\n");
            if (!Directory.Exists(EnVars["MROOT"] + "updates"))
                Directory.CreateDirectory(EnVars["MROOT"] + "updates");

            File.Copy(EnVars["MBIN"] + ProjectName + ".exe", EnVars["MROOT"] + "updates\\" + ProjectName + ".exe", true);
            createInstaller();
        }

        private void createInstaller()
        {
            Write("Creating installer..\n");
            var process = new Process
            {
                StartInfo = new ProcessStartInfo()
                {
                    FileName = EnVars["ISS"] + "iscc.exe",
                    Arguments = "/o" + EnVars["MROOT"] + "release /dVersion=" +  Version + " /dAppName=" + ProjectName + " /dSetupName=" + ProjectName.ToLower() + " " + EnVars["MROOT"] + ProjectName.ToLower() + "_setup.iss",
                    UseShellExecute = false,
                    RedirectStandardOutput = true
                }
            };

            process.OutputDataReceived += process_OutputDataReceived;
            process.Start();
            process.BeginOutputReadLine();
            process.WaitForExit();

            cleanup();
        }

        private void cleanup()
        {
            Write("Cleaning up residual files...\n");
            string[] files = Directory.GetFiles(EnVars["CURDIR"]);
            foreach(string file in files)
            {
                if (file.Contains("Makefile") 
                    || file.Contains("object_script")
                    || file.Contains("ui_"))
                {
                    writer.WriteLine("Deleting file: " + file);
                    writer.Flush();
                    File.Delete(Path.Combine(EnVars["CURDIR"], file));
                }
            }

            writer.WriteLine("Deleting file: " + EnVars["MBIN"] + ProjectName + ".exe");
            File.Delete(EnVars["MBIN"] + ProjectName + ".exe");

            Directory.Delete(EnVars["CURDIR"] + "release", true);
            Directory.Delete(EnVars["CURDIR"] + "debug", true);

            watch.Stop();

            int second = (int)watch.ElapsedMilliseconds / 1000;
            int minute = (int)watch.ElapsedMilliseconds / 60000;

            elapsedTime = String.Format("{0}m:{1}s", minute, second);

            writer.WriteLine("\nElapsed build time: " + elapsedTime);

            writer.WriteLine("\n=================================================");
            writer.WriteLine("End of log");
            writer.WriteLine("=================================================");

            writer.Close();
            os.Close();

            Write("\nBuild 100% Successfull! Total build time: " + elapsedTime);
            Write("Setup file can be found at:\n" + EnVars["MROOT"] + "release");
            Write("A log has also been written with full details on compilation\n");
            Write("Press <RETURN> to close");
            Console.Read();
        }

        private void Write(string message)
        {
            Console.WriteLine(message);
            try
            {
                writer.WriteLine(message);
                writer.Flush();
            }
            catch (Exception) { }
        }

        void process_OutputDataReceived(object sender, DataReceivedEventArgs e)
        {
            writer.WriteLine(e.Data);
            writer.Flush();
        }
    }
}
