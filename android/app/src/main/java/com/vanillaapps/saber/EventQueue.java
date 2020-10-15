package com.vanillaapps.saber;

import com.vanillaapps.saber.models.AppEvent;

import java.util.Observable;
import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;

public class EventQueue extends Observable {
    static EventQueue INSTANCE = null;

    private Queue<AppEvent> queue = new ArrayBlockingQueue<AppEvent>(1000);

    synchronized void enqueue(AppEvent appEvent){
        queue.add(appEvent);
        notifyObservers();
    }

    static EventQueue getInstance(){
        if(INSTANCE == null){
            INSTANCE = new EventQueue();
        }
        return INSTANCE;
    }

    synchronized AppEvent dequeue(){
        return queue.remove();
    }

    synchronized public Queue<AppEvent> getQueue() {
        return queue;
    }
}
