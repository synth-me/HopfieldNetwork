# HopfieldNetwork
# Setup 

##### all you need to do is run the file :
```
git clone [this repo]
setup.bat 
```
##### or manually 
```
zef install JSON::Tiny
zef install Terminal::ANSIColor
```


# Some theory : 
##### The theory behind Hopfield Networks can be found here : 
 [EDX free course about computational neuroscience !](https://www.edx.org/course/computational-neuroscience-neuronal-dynamics-of-co)
 
##### The ideia : 
<p>The goal of Hopfield models is to a mathematical model to associative memory especially for images</p>
<p>Here I could implement a first of this model, but there's still a long path towards a totally useful model</p>

### Start :
##### Images can be binary multidimensional arrays like this example :
<p>(Illustrative example)</p>
<img src="https://www.codeproject.com/KB/AI/1200367/hopfieldgrid.png">

##### Here we create a hash from multidimensional arrays that are our images from the /images folder 
```Perl 6
my $trainingset = ImageSet.new(
    myimages=>{
        "image0"=>"image0.json",
        "image1"=>"image1.json"
    }
);
my $testingset = ImageSet.new(
    myimages=>{
        "image2"=>"image2.json"
    }
);
# this is the info that will populate our training information 
my $mytrainingsetfinal = $trainingset.genSet(8); 
# this will be the ones used to test the net 
my $mytestingsetfinal = $testingset.genSet(8);

```

##### To create a new net : 

```Perl 6
my $model = HopfieldNetwork.new(
    dataset=>$mytrainingsetfinal,
    testset=>$mytestingsetfinal,
    title=>"mynet"
); # here we use our generated formatted data to feed the net 
```

##### To run a prediction :
```Perl 6 
$model.predict # store the result 
$model.showResult # show the similarities 
```
##### To save your current model :
```Perl 6 
$model.export # this goes as mymodel.json
```
##### To load a new model : 
```Perl 6 
$mode.loadModel("mynet") # here goes the name of the json exported from model
```
### Future goals :
* Implementation of **zef** or **panda** module 
* Implementation of native **C API** to process the **binary vectors** and transformations
* Implementation of higher features from **Hopfield Models** and variations 
