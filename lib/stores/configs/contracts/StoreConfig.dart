import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../HiveStore.dart';
import '../../Store.dart';

abstract class StoreConfig<ObjectIdType, ObjectType>{

  Store _store;
  
  Inserter<ObjectIdType, ObjectType> inserter;
  
  Deleter<ObjectIdType, ObjectType> deleter;
  
  Updater<ObjectIdType, ObjectType> updater;
  
  Fetcher<ObjectIdType,ObjectType> reader;
  
}


abstract class Fetcher <ObjectIdType, ObjectType>{
  
  Store store;

  Fetcher({@required Store store});
  
  ObjectType fetch (ObjectIdType id){
    return (store as HiveStore).getObject(id);
  }

  List<ObjectType> fetchAll(){
    return (store as HiveStore).getAll() as List<ObjectType>;
  }

}


abstract class Updater <ObjectIdType, ObjectType>{

  Updater({@required Store store});

  Store store;

  update(ObjectIdType key, ObjectType object){
    (store as HiveStore).putObject(key, object);
  }
}


abstract class Deleter<ObjectIdType, ObjectType> {

  Deleter({@required Store store});

  Store store;

  delete(ObjectIdType key){
    (store as HiveStore).removeObject(key);
  }


  deleteAll(){
    (store as HiveStore).clear();
  }
}


abstract class Inserter<ObjectIdType, ObjectType> {

  Inserter({@required Store store});

  Store store;

  insert(ObjectIdType key, ObjectType object){
    (store as HiveStore).putObject(key, object);
  }
}


class HiveStoreConfig<ObjectIdType, ObjectType> extends StoreConfig<ObjectIdType, ObjectType>{

  Store _store;

  Inserter<ObjectIdType, ObjectType> inserter;

  Deleter<ObjectIdType, ObjectType> deleter;

  Updater<ObjectIdType, ObjectType> updater;

  Fetcher<ObjectIdType,ObjectType> reader;

  HiveStoreConfig({@required Store store}){
    _store = store;
    reader = HiveFetcher<ObjectIdType, ObjectType>(store: _store);
    deleter = HiveDeleter<ObjectIdType, ObjectType>(store: _store);
    inserter = HiveInserter<ObjectIdType, ObjectType>(store: _store);
    updater = HiveUpdater<ObjectIdType, ObjectType>(store: _store);
  }

}


class HiveFetcher <ObjectIdType, ObjectType> extends Fetcher <ObjectIdType, ObjectType>{

  Store store;

  HiveFetcher({@required  this.store});

  ObjectType fetch (ObjectIdType id){
    return (store as HiveStore).getObject(id);
  }

  fetchAll(){
    return (store as HiveStore).getAll();
  }

}


class HiveUpdater <ObjectIdType, ObjectType> extends Updater<ObjectIdType, ObjectType>{

  HiveUpdater({@required  this.store});

  Store store;

  update(ObjectIdType key, ObjectType object){
    (store as HiveStore).putObject(key, object);
  }
}


class HiveDeleter<ObjectIdType, ObjectType> extends Deleter<ObjectIdType, ObjectType>{

  HiveDeleter({@required  this.store});

  Store store;

  delete(ObjectIdType key){
    (store as HiveStore).removeObject(key);
  }

}


class HiveInserter<ObjectIdType, ObjectType> extends Inserter<ObjectIdType, ObjectType>{

  HiveInserter({@required  this.store});

  Store store;

  insert(ObjectIdType key, ObjectType object){
    (store as HiveStore).putObject(key, object);
  }
}

