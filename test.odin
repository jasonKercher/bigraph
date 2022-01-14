package bigraph

import "core:testing"

@test
test_graph :: proc(t: ^testing.T) {

	graph := make_graph(i64)

	node1 := add(&graph, 1)
	node2 := add(&graph, 2)
	node3 := add(&graph, 3)
	node1.out[0] = node2
	node2.out[0] = node3

	res: ^Node(i64)

	res = traverse(&graph)
	testing.expect_value(t, res.data, 1)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 2)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 3)
	res = traverse(&graph)
	testing.expect_value(t, res, nil)

	/* This will have no affect since these are
	 * unreachable and we did not derive_roots.
	 */
	node4 := add(&graph, 4)
	node5 := add(&graph, 5)
	node4.out[1] = node2
	node5.out[0] = node4

	reset(&graph)

	res = traverse(&graph)
	testing.expect_value(t, res.data, 1)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 2)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 3)
	res = traverse(&graph)
	testing.expect_value(t, res, nil)

	/* node5 will become a new root */
	derive_roots(&graph)
	reset(&graph)

	res = traverse(&graph)
	testing.expect_value(t, res.data, 1)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 2)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 3)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 5)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 4)
	res = traverse(&graph)
	testing.expect_value(t, res, nil)

	/* Let's check the breadth firstness */
	node1.out[1] = node4
	node4.out[0] = node1

	/* 1 and 4 still root */
	reset(&graph)

	res = traverse(&graph)
	testing.expect_value(t, res.data, 1)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 2)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 4)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 3)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 5)
	res = traverse(&graph)
	testing.expect_value(t, res, nil)

	/* Now, only 5 will be root */
	derive_roots(&graph)
	reset(&graph)

	res = traverse(&graph)
	testing.expect_value(t, res.data, 5)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 4)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 1)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 2)
	res = traverse(&graph)
	testing.expect_value(t, res.data, 3)
	res = traverse(&graph)
	testing.expect_value(t, res, nil)

	destroy(&graph)
}
