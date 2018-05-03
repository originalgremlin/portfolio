<?php
class PositionRating extends Rating {
    public function __construct ($positionId) {
        global $db;
        $this->id = $positionId;
        $sql = sprintf(
            "select gender, avg(difficulty) as difficulty, avg(age) as age
            from PositionRating
            where positionId=%d
            group by gender",
            $db->escape_string($this->id)
        );
        $result = $db->query($sql);
        while ($data = $result->fetch_assoc()) {
            $gender     = $data["gender"];
            $difficulty = $data["difficulty"];
            $age        = $data["age"];
            $this->rating[$gender]["difficulty"] = $difficulty;
            $this->rating[$gender]["age"]        = $age;
        }
    }

    public static function rate ($foreignKey, $userId, $gender, $ratingType, $rating) {
        global $db;
        $foreignKey = $db->escape_string($foreignKey);
        $gender     = $db->escape_string($gender);
        $userId     = is_int($userId) ?
            $db->escape_string($userId) :
            "null";
        switch ($ratingType) {
            case "difficulty":
                $difficulty = $db->escape_string($rating);
                $age        = "null";
                break;
            case "age":
                $difficulty = "null";
                $age        = $db->escape_string($rating);
                break;
            default:
                $difficulty = "null";
                $age        = "null";
                break;
        }

        $sql = sprintf(
            "insert into PositionRating
            (positionId, userId, gender, difficulty, age)
            values (%d, %s, '%s', %s, %s)",
            $foreignKey, $userId, $gender, $difficulty, $age
        );
        $db->query($sql);
    }
}
?>