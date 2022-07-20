package hanabiEnv;

public class HanabiCardHolder {
    private String owner;
    private int numSlots;
    private HanabiCard[] cards = new HanabiCard[5];

    public HanabiCardHolder(String owner, int numSlots) {
        this.owner = owner;
        this.numSlots = numSlots;
        for (int i = 0; i < numSlots; i++) {
            this.cards[i] = null;
        }
    }

    public String getOwner() {
        return owner;
    }

    public int getNumSlots() {
        return numSlots;
    }

    public HanabiCard getCard(int slot) {
        return cards[slot - 1];
    }

    public boolean placeCard(int slot, String color, int rank) {
        if (slot < 1 || slot > numSlots) {
            throw new IllegalArgumentException(String.format("Slot position must be between 1 and %d", numSlots));
        }
        HanabiCard prevCard = cards[slot - 1];
        if (prevCard != null) {
            return false;
        }
        cards[slot - 1] = new HanabiCard(color, rank);
        return true;
    }

    public HanabiCard pickCard(int slot) {
        if (slot < 1 || slot > numSlots) {
            throw new IllegalArgumentException(String.format("Slot position must be between 1 and %d", numSlots));
        }
        HanabiCard card = cards[slot - 1];
        cards[slot - 1] = null;
        return card;
    }

}
