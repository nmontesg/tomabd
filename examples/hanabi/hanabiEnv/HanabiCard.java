package hanabiEnv;

public class HanabiCard {
    private String color;
    private int rank;

    public HanabiCard(String color, int rank) {
        this.color = color;
        this.rank = rank;
    }

    public String getColor() {
        return color;
    }

    public int getRank() {
        return rank;
    }

}
