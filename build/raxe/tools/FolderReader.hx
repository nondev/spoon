package raxe.tools;using Lambda;using StringTools;import sys.FileSystem;
import sys.io.File;

/** 
* Utility to deal with folders
* @author Axel Anceau (Peekmo)
 **/
@:tink class FolderReader{
  /** 
  * Returns an array of all files which are in the given folder and its
  * subfolders
  * @param rootFolder Root folder for the search
  * @return Files found
   **/
  public static function getFiles(rootFolder: String) : Array<String> return{
    var files : Array<String> = new Array<String>();

    if(FileSystem.exists(rootFolder)){
      var folders : Array<String> = FileSystem.readDirectory(rootFolder);

      for(file in folders.iterator()){
        var path : String = rootFolder + '/' + file;

        if(FileSystem.isDirectory(path)){
          var data : Array<String> = getFiles(path);

          for(i in data){
            files.push(i);
          }
        }else{
          files.push(path);
        }
      }
    }

    return files;
  }

  /** 
  * Creates a file to the given path, with the given content
  * (Creates all directories if they not exists)
  * @param path     Path to the file (each folders separated by '/')
  * @param ?content File's content
   **/
  public static function createFile(path : String, ?content : String) : Void return{
    
    if(path.indexOf('/') > 0){
      createDirectory(path);
    }

    if(content == null){
      content = '';
    }

    File.saveContent(path, content);
  }

  /** 
  * Creates the given directory (and all path's directories if needed)
  * @param path Path to the given directory
   **/
  public static function createDirectory(path : String) : Void return{
    var parts : Array<String> = path.split('/');
    var done : String = null;

    for(part in parts.iterator()){
      done = done == null ? part : done + '/' + part;

      if(!FileSystem.exists(done)){
        FileSystem.createDirectory(done);
      }
    }
  }

  /** 
  * Copy all files from source to destination
  * @param source      Source's path
  * @param destination Destination's path
   **/
  public static function copyFileSystem(source : String, destination : String) : Void return{
    try{
      if(source.endsWith('/')){
        source = source.substr(0, -1);
      }

      
      if(!FileSystem.isDirectory(source)){
        createFile(destination, File.getContent(source));
      }else{
        var files : Array<String> = FileSystem.readDirectory(source);

        for(file in files.iterator()){
          if(FileSystem.isDirectory(source + '/' + file)){
            createDirectory(destination);
          }

          
          copyFileSystem(source + '/' + file, destination + '/' + file);
        }
      }
    }catch(ex: String){
      throw('Unable to copy ' + source + ' to ' + destination + ' : ' + ex);
    }
  }
}
