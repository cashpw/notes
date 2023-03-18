import java.lang.Math;
import java.util.Optional;
import java.util.ArrayList;

interface Heap<T> {
   boolean add(T value);
   Optional<T> peek();
   Optional<T> poll();
}

class MaxHeap<T extends Comparable<? super T>> implements Heap<T> {
    private ArrayList<T> array;

    MaxHeap() {
        this.array = new ArrayList<T>();
    }

    @Override
    public boolean add(T value) {
        array.add(value);
        heapifyUp(array.size() - 1);

        return true;
    }

    @Override
    public Optional<T> peek() {
        if (array.isEmpty()) {
            return Optional.empty();
        }

        return Optional.of(array.get(0));
    }

    @Override
    public Optional<T> poll() {
        if (array.isEmpty()) {
            return Optional.empty();
        }

        T max = array.get(0);
        array.set(0, array.get(array.size() - 1));
        array.remove(array.size() - 1);
        heapifyDown(0);

        return Optional.of(max);
    }

    private boolean heapifyUp(Integer index) {
        if (index == 0) {
            return true;
        }

        if (!indexInBounds(index)) {
            return false;
        }

        Integer parentIndex = parentIndexOf(index);
        if (array.get(index).compareTo(array.get(parentIndex)) > 0) {
            swap(index, parentIndex);
        }
        return heapifyUp(parentIndex);
    }

    private boolean heapifyDown(Integer index) {
        if (!indexInBounds(index)) {
            return false;
        }

        Integer largestChildIndex = -1;
        Optional<Integer> leftChildIndex = leftChildIndexOf(index);
        Optional<Integer> rightChildIndex = rightChildIndexOf(index);
        if (leftChildIndex.isPresent() && array.get(leftChildIndex.get()).compareTo(array.get(index)) > 0) {
            largestChildIndex = leftChildIndex.get();
        }
        if (rightChildIndex.isPresent() && array.get(rightChildIndex.get()).compareTo(array.get(index)) > 0) {
            largestChildIndex = rightChildIndex.get();
        }

        if (largestChildIndex < 0) {
            return true;
        }

        swap(index, largestChildIndex);

        return heapifyDown(largestChildIndex);
    }

    private boolean swap(Integer indexA, Integer indexB) {
        if (!indexInBounds(indexA) || !indexInBounds(indexB)) {
            return false;
        }

        T a = array.get(indexA);
        array.set(indexA, array.get(indexB));
        array.set(indexB, a);

        return true;
    }

    private boolean indexInBounds(Integer index) {
        return index >= 0 && index < array.size();
    }

    private Optional<Integer> rightChildIndexOf(Integer index) {
        Integer rightChildIndex = (2*index) + 2;
        if (!indexInBounds(rightChildIndex)) {
            return Optional.empty();
        }

        return Optional.of(rightChildIndex);
    }

    private Optional<Integer> leftChildIndexOf(Integer index) {
        Integer leftChildIndex = (2*index) + 1;
        if (!indexInBounds(leftChildIndex)) {
            return Optional.empty();
        }

        return Optional.of(leftChildIndex);
    }

    private static Integer parentIndexOf(Integer index) {
        return Math.floorDiv((index - 1), 2);
    }
}

public class Main {
    public static void main(String[] args) {
        MaxHeap<Integer> maxHeap = new MaxHeap<Integer>();
        maxHeap.add(14);
        System.out.println(maxHeap.peek());
        maxHeap.add(22);
        System.out.println(maxHeap.peek());
        maxHeap.add(5);
        System.out.println(maxHeap.peek());
        maxHeap.add(28);
        System.out.println(maxHeap.peek());
        maxHeap.poll();
        System.out.println(maxHeap.peek());
    }
}