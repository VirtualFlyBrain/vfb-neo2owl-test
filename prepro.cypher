MATCH (n {qsl:'deprecated_owl'}) 
MATCH (s {qsl:'comment_rdfs'}) 
MATCH (t {qsl:'label_rdfs'}) set t.qsl = 'label' set s.qsl = 'comment' set n.qsl = 'deprecated' return n