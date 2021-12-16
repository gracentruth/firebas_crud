# firebas_crud
https://funncy.github.io/flutter/2021/03/06/firestore/
1. Create
- FirebaseFirestore.collection('컬렉션이름').add({'필드명':필드내,})
  doc이름을 지정해서 추
- FirebaseFirestore.collection('컬렉션이름').doc('document이름').set({'필드명':'필드내용'})

2. Read
*StreamBuilder
   - setState는 전체를 build하지만 Streambuilder을 사용하면 해당 부분만 build된다. 
   - 비동기 작업에서의 문제점을 해결 
    
3. Update
   FirebaseFirestore.instance.collection('todo').doc(doc.id).update({'isdone':!doc['isdone']});
   
4. Delete
-  FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();
