use JSON::Tiny;
use Terminal::ANSIColor;


sub equalityProb(Array $vector0,Array $vector1 --> Rat) {
# here we compare each of the vectors against the equivalent one 
# from the source vector 
    my Int $l0 = $vector0.elems;
    my Int $p = 0 ;
    for 0..$vector0.elems-1 {
        my Int $i = $vector0[$_];
        my Int $v = $vector1[$_];
        if $i == $v {$p+=1;}else{$p+=-1;}
    }
    my Rat $f = ($p/$l0)*100;
    if $f < 0.0 {$f = 0.0};
    return $f;
}

sub CompareVectors(Array $VectorSource,Array $VectorTarget --> Rat){
# given that arrays are mulitidimensional we need to iterate over each of them 
    my Int $l0 = $VectorSource.elems;
    my Array $p = [] ;
    for 0..$VectorSource.elems-1 {
        my Array $f0 = $VectorSource[$_];
        my Array $f1 = $VectorTarget[$_];
        my Rat $e = equalityProb $f0, $f1;
        $p.push($e) ;
    }
    my Rat $w = (map({.sum},$p)[0])/$p.elems;
    if $w < 0 {
        $w = 0.0
    }
    return $w;
}

class HopfieldNetwork {
    has Hash $.dataset ; # that one is the train dataset  
    has Hash $.testset ; # that one is the test dataset  
    has Str $.title ; # here we attribute a name to the net that will be saved 
    my Array $.result = [];

    method predict { # here we test the model with our new information  
        for self.testset.kv -> $keys0,$values0 {
            my Hash $n = {$keys0 => []};        
            for self.dataset.kv -> $keys1,$values1 {
                my Rat $r = CompareVectors $values0, $values1; 
                $n{$keys0}.push({$keys1=>$r});
            }
            self.result.push($n)
        } 
    }

    method showResult { 
# here you can print the result of the processing with more details 
        my Array $log = [];
        for self.result {
            for $_.kv -> $keys, $values {
                my Str $Log = "";
                for $values.kv -> $x,$y {
                        for $values{$x}.kv -> $nKeys,$nValues {
                            for $nValues.kv -> $k,$v {
                                $Log~="\n{$x} comparison to {$k} ";
                                my Str $color;
                                if $v > 49.9 {
                                    $color = "green";    
                                }else{
                                    $color = "red";
                                }
                                my $total = "similarity is "~colored("{$v}%",$color);
                                $Log~=$total;
                            }
                        };
                    };
                $log.push("\n---");
                $log.push($Log);
                };
            };
        say $log;
    };

    method loadModel(Str $name) { # here we load a pre configured model
        try {
        say "loading a new model";
        my $modelJson = "models/{$name}.json".IO.slurp;
        my Hash $info = from-json($modelJson);
        for $info.kv -> $keys, $values {
            if $keys === "dataset" {
                $!dataset = $values;
            }elsif $keys === "testset" {
                $!testset = $values;
            };
            CATCH {
                default {
                    say colored("error on loading your model\ncheck the model's name...","red")}
                }
            };
        };
    };
    method exportModel { # here we export the current model 
        say "generating models folder"; 
        try {
            shell "mkdir models";
            CATCH {
                default {
                    say colored("models already exists...","yellow");
                    say colored("using the existent folder","green")}
                }
        };
        my $mainModel = {
            dataset=>self.dataset,
            testset=>self.testset 
        }
        my $modelJson = open "models/{self.title}.json", :w;
        $modelJson.say(to-json($mainModel));
    }
  } 

class ImageSet {
# get a hash of the images and their names 
# like name => image.json 
    has Hash $.myimages  ;

    method genSet(Int $x) {
# here we generate formatted arrays that can be used 
# to feed a hopfield network 
        my Hash $fInfo ;
        for self.myimages.kv -> $keys, $values {
            my $source = "images/{$values}".IO.slurp;
            my %img = from-json($source);
            my Array $vector = %img{"image"};
            my Int $counter = 0;
            my @SubStorage ; 
            my @Storage;
            for 0..$vector.elems-1 {
                my $elm = $vector[$_];
                if $counter == $x {
                    @Storage.push(@SubStorage);
                    @SubStorage = [];
                    $counter = 0 ;
                };
                @SubStorage.push($elm);
                $counter+=1
            };
            $fInfo{$keys} = @Storage;
        };
        return $fInfo;
    };
};

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
my $mytrainingsetfinal = $trainingset.genSet(8); 
my $mytestingsetfinal = $testingset.genSet(8);


my $model = HopfieldNetwork.new(
    dataset=>$mytrainingsetfinal,
    testset=>$mytestingsetfinal,
    title=>"mynet"
); 
$model.predict ;
$model.showResult ;
