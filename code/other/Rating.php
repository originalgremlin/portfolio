<?php
abstract class Rating extends ElephantElement {  
    // all the user ratings for this element as an associative array
    protected $rating = array(
        "male" => array(
            "difficulty" => null,
            "value"      => null,
            "age"        => null
        ),
        "female" => array(
            "difficulty" => null,
            "value"      => null,
            "age"        => null
        )
    );

    // the constuctor fills the ratings array from the database
    abstract public function __construct ($id);
    
    // rate it
    abstract public static function rate ($foreignKey, $userId, $gender, $ratingType, $rating);

    public static function sanitize ($rating) {
        return max(RATING_MIN_VALUE, min(intval($rating), RATING_MAX_VALUE));
    }

    // accessor functions
    public function getName () {
        return get_class($this);
    }

    public function getRating () {
        return $this->rating;
    }

    public function getMaleDifficulty () {
        return $this->rating["male"]["difficulty"];
    }

    public function getMaleValue () {
        return $this->rating["male"]["value"];
    }

    public function getMaleAge () {
        return $this->rating["male"]["age"];
    }

    public function getFemaleDifficulty () {
        return $this->rating["female"]["difficulty"];
    }

    public function getFemaleValue () {
        return $this->rating["female"]["value"];
    }

    public function getFemaleAge () {
        return $this->rating["female"]["age"];
    }

    // output functions
    public function toXML () {
        $rv = "<rating>";
        $rv .= sprintf('<male_difficulty><![CDATA[%.2f]]></male_difficulty>',     $this->getMaleDifficulty());
        $rv .= sprintf('<male_value><![CDATA[%.2f]]></male_value>',               $this->getMaleValue());
        $rv .= sprintf('<male_age><![CDATA[%.2f]]></male_age>',                   $this->getMaleAge());
        $rv .= sprintf('<female_difficulty><![CDATA[%.2f]]></female_difficulty>', $this->getFemaleDifficulty());
        $rv .= sprintf('<female_value><![CDATA[%.2f]]></female_value>',           $this->getFemaleValue());
        $rv .= sprintf('<female_age><![CDATA[%.2f]]></female_age>',               $this->getFemaleAge());
        $rv .= "</rating>";
        return $rv;
    }

    public function toJSON () {
        $rv = "{";
        $rv .= sprintf('"maleDifficulty": %.2f',     $this->getMaleDifficulty());
        $rv .= sprintf(', "maleValue": %.2f',        $this->getMaleValue());
        $rv .= sprintf(', "maleAge": %.2f',          $this->getMaleAge());
        $rv .= sprintf(', "femaleDifficulty": %.2f', $this->getFemaleDifficulty());
        $rv .= sprintf(', "femaleValue": %.2f',      $this->getFemaleValue());
        $rv .= sprintf(', "femaleAge": %.2f',        $this->getFemaleAge());
        $rv .= "}";
        return $rv;
    }

    public function __toString () {
        $class = get_class($this);
        $rv = sprintf("%s: %s\n", $class, print_r($this->rating, true));
        return $rv;    
    }

    public static function getIdFromName ($name, $languageId = LANGUAGE_DEFAULT) {
        return null;
    }
}
