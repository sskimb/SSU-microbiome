# tree should be in phylo class, where edge, edge.length, tip.label, node.label should be defined.
# treePruned, descendents, parent, ancestor, and relatives accepts and produces node labels.
# pruning, getDescendents works with node IDs

treeFixNaN <- function(tree.old=tree) {
	edge        <- tree.old$edge
	edge.length <- tree.old$edge.length
	tip.label   <- tree.old$tip.label
	node.label  <- tree.old$node.label
	all.label   <- c(tip.label, node.label)
	NAN <- which( is.nan( edge.length ) )
	if( length( NAN ) > 0 ) {
		PAR <- edge[ NAN, 1 ]
		SEL <- edge[ NAN, 2 ]
		SIB <- setdiff( edge[ match( PAR, edge[ , 1] ), 2 ], SEL )
		tree.old$edge.length[NAN] <- edge.length[ match( SIB, edge[, 2] ) ]
		print( "NaN in edge.length is detected and set to its sib's value" )
		print( cbind( all.label[SEL], all.label[SIB] ) )
	} else {
		print( "NaN is not detected" )
	}
	tree.old
}
	
treeSimple <- function(tree.old=tree) {
# single child node is merged to parent
	edge        <- tree.old$edge
	edge.length <- tree.old$edge.length
	tip.label   <- tree.old$tip.label
	node.label  <- tree.old$node.label
	all.label   <- c(tip.label, node.label)
	ntips.old   <- length(tip.label)
	singlePar   <- as.numeric( names( which( table( edge[,1] ) == 1 ) ) )
	print( paste( length(singlePar), 'single-child parents found' ) )
	NS <- 0
	for( i in 1:length(singlePar) ) {
		pid <- singlePar[i]
		eid <- which( edge[,1] == pid )
		if( length(eid) != 1 ) {
			NS <- NS + 1
			if( NS < 10 ) print( paste('NodeID', pid, 'already removed') )
			next
		}
		cid <- edge[ eid, 2 ]
		fid <- which( edge[,2] == pid )
		if( length(fid) == 0 ) {
			print( paste( cid, '>', eid, '>>', pid, '>>>', fid, '>>>>', gid ) )
			next
		}
		gid <- edge[ fid, 1 ]
		edge[fid,2] <- cid
		edge[eid,1] <- NA
		edge.length[fid] <- edge.length[fid] + edge.length[eid]
#		edge.length[eid] <- NA
	}
	SV <- which( ! is.na(edge[,1]) )
	edge <- edge[ SV, ]
	edge.length <- edge.length[ SV ]
	NODES <- unique( sort( c( edge[,1], edge[,2] ) ) )
	print( paste( length(NODES), 'unique NodeIDs' ) )
	edge[,1] <- match( edge[,1], NODES )
	edge[,2] <- match( edge[,2], NODES )
#	print( paste0( 'Original all labels', head(all.label) ) )
	all.label <- all.label[NODES]
#	print( paste0( 'Updated  all labels', head(all.label) ) )
	node.label <- all.label[-(1:ntips.old)]
	tree.old$node.label <- node.label
	tree.old$Nnode <- length(node.label)
	tree.old$edge <- edge
	tree.old$edge.length <- edge.length
	tree.old
}

junk <- function(tree.old) {

	XD <- 0
	YD <- 0
	NI <- 0
	for( i in 1:length(all.label) ) {
		pid <- tree.old$edge[ which( tree.old$edge[,2] == i ), 1]
		eid <- which( tree.old$edge[,1] == pid )
		nch <- length( eid )
		if( nch > 1 ) next
		NI <- NI + 1
		if( NI < 10 ) {
			print( paste0( 'Tip ', i ) )
			print( paste( eid, '>', pid ) )
		}
		while( nch == 1 ) {
			XD <- c(XD, pid)
			YD <- c(YD, eid)
			PD <- which( tree.old$edge[,2] == pid )
			if( length(PD) == 0 ) {
				if( NI < 10 ) print( paste( 'No edge to', pid, 'terminate this tip' ) )
				break
			}
			gid <- tree.old$edge[PD, 1]
			fid <- which( tree.old$edge[,1] == gid & tree.old$edge[,2] == pid )
			if( length(fid) != 1 ) {
				if( NI < 10 ) print( paste( fid, 'Unexpected edge to', pid ) )
				break
			}
			tree.old$edge.length[fid] <- tree.old$edge.length[fid] + tree.old$edge.length[eid]
			tree.old$edge[fid,2] <- i
			pid <- gid
			eid <- which( tree.old$edge[,1] == pid )
			nch <- length( eid )
			if( NI < 10 ) {
				print( paste( eid, '>', pid, nch ) )
			}
			if( nch > 1 ) {
				if( NI < 10 ) print( paste( '# of children', nch, 'for', pid, 'done with this tip' ) )
				break
			}
		}
	}
	XD <- XD[-1]
	print( paste0( length(XD), ' nodes removed') )
	RD <- setdiff( 1:length(all.label), XD )
	all.label <- all.label[RD]
	print( paste0( length(RD), ' tips+nodes saved') )
	YD <- YD[-1]
	print( paste0( length(YD), ' edges removed') )
	if( length(XD) > 0 ) {
		tree.old$edge <- tree.old$edge[-YD,]
		tree.old$edge[,1] <- match( tree.old$edge[,1], RD )
		tree.old$edge[,2] <- match( tree.old$edge[,2], RD )
		tree.old$edge.length <- tree.old$edge.length[-YD]
		tree.old$node.label <- all.label[-(1:ntips.old)]
		tree.old$Nnode <- length( tree.old$node.label )
	}
	tree.old
}

treeClean <- function(tree.old=tree) {
# single child node is merged to parent
	ntips.old <- length(tree.old$tip.label)
	all.label <- c(tree.old$tip.label, tree.old$node.label)
	XD <- 0
	YD <- 0
	NI <- 0
	for( i in 1:ntips.old ) {
		pid <- tree.old$edge[ which( tree.old$edge[,2] == i ), 1]
		eid <- which( tree.old$edge[,1] == pid )
		nch <- length( eid )
		if( nch > 1 ) next
		NI <- NI + 1
		if( NI < 10 ) {
			print( paste0( 'Tip ', i ) )
			print( paste( eid, '>', pid ) )
		}
		while( nch == 1 ) {
			XD <- c(XD, pid)
			YD <- c(YD, eid)
			PD <- which( tree.old$edge[,2] == pid )
			if( length(PD) == 0 ) {
				if( NI < 10 ) print( paste( 'No edge to', pid, 'terminate this tip' ) )
				break
			}
			gid <- tree.old$edge[PD, 1]
			fid <- which( tree.old$edge[,1] == gid & tree.old$edge[,2] == pid )
			if( length(fid) != 1 ) {
				if( NI < 10 ) print( paste( fid, 'Unexpected edge to', pid ) )
				break
			}
			tree.old$edge.length[fid] <- tree.old$edge.length[fid] + tree.old$edge.length[eid]
			tree.old$edge[fid,2] <- i
			pid <- gid
			eid <- which( tree.old$edge[,1] == pid )
			nch <- length( eid )
			if( NI < 10 ) {
				print( paste( eid, '>', pid, nch ) )
			}
			if( nch > 1 ) {
				if( NI < 10 ) print( paste( '# of children', nch, 'for', pid, 'done with this tip' ) )
				break
			}
		}
	}
	XD <- XD[-1]
	print( paste0( length(XD), ' nodes removed') )
	RD <- setdiff( 1:length(all.label), XD )
	all.label <- all.label[RD]
	print( paste0( length(RD), ' tips+nodes saved') )
	YD <- YD[-1]
	print( paste0( length(YD), ' edges removed') )
	if( length(XD) > 0 ) {
		tree.old$edge <- tree.old$edge[-YD,]
		tree.old$edge[,1] <- match( tree.old$edge[,1], RD )
		tree.old$edge[,2] <- match( tree.old$edge[,2], RD )
		tree.old$edge.length <- tree.old$edge.length[-YD]
		tree.old$node.label <- all.label[-(1:ntips.old)]
		tree.old$Nnode <- length( tree.old$node.label )
	}
	tree.old
}

treePruned <- function(y, tree.old=tree) {
# y: tip+node labels to keep (character vector class)
# tree.old: original tree in class phylo
# tree.new: pruned tree in class phylo
	tree.new <- tree.old
	ntips.old <- length(tree.old$tip.label)
	all.label <- c(tree.old$tip.label, tree.old$node.label)
	pruned <- pruning(match(y,all.label), tree.old=tree.old, index.only=FALSE)
	edge.new <- pruned[[1]]
	edge.new.length <- pruned[[2]]
	u1 <- unique( edge.new[,1] )	# parent
	u2 <- unique( edge.new[,2] )	# child
	u2m1 <- sort( setdiff( u2, u1 ) )	# tips
	u1u2 <- union( u1, u2 )
	u1m2 <- sort( setdiff( u1u2, u2m1 ) )	# nodes
	u1u2 <- c( u2m1, u1m2 )		# tip first, node next
	edge.new[,1] <- match( edge.new[,1], u1u2 )
	edge.new[,2] <- match( edge.new[,2], u1u2 )
	tree.new$tip.label <- all.label[u2m1]
	tree.new$node.label <- all.label[u1m2]
	tree.new$edge <- edge.new
	tree.new$edge.length <- edge.new.length
	tree.new$Nnode <- length(u1m2)
#	tree.new$tip.label <- tree.new$tip.label[u2m1]
#	tree.new$node.label <- tree.new$node.label[u1m2-length(tree.new$tip.label)]
	tree.new
}

pruning <- function(x, tree.old, index.only=FALSE) {
# x: tip+node IDs to keep (integer vector class)
# tree.old: original tree in class phylo
# index.only: output IDs of surviving tip+node, instead of a usual
# list of surviving edge (named edge.new) and edge.length (named edge.new.length)
	edge.new <- tree.old$edge
	edge.new.length <- tree.old$edge.length
	u1 <- unique( edge.new[,1] )	# parent
	u2 <- unique( edge.new[,2] )	# child
	u2m1 <- setdiff( u2, u1 )	# tips
	u2rm <- setdiff( u2m1, x )	# tips to be removed
	XD <- which( edge.new[,2] %in% u2rm )
	nXD <- length(XD)
	print( paste(nXD, 'removed') )
	pXD <- 0
	while( nXD > pXD ) {
		pXD <- nXD
		u1 <- unique( edge.new[-XD,1] )
		u2 <- unique( edge.new[-XD,2] )
		u2m1 <- setdiff( u2, u1 )
		u2rm <- setdiff( u2m1, x )
		XD <- c(XD, which( edge.new[,2] %in% u2rm ))
		nXD <- length(XD)
		print( paste(nXD, 'removed') )
	}
	if( index.only ) {
		setdiff( 1:dim(edge.new)[1], XD )
	} else {
		list( edge.new=edge.new[-XD,], edge.new.length=edge.new.length[-XD] )
	}
}

getDescendents <- function(x, edge, ntips) {
# recursive calling function to sought all descendents
# x: node ID in edge from phylo class
# ntips: number of tips
# outputs an integer vector of node IDs (excluding self)
	res <- 0
        id <- which( edge[,1] == x )
	if( length(id) > 0 ) {
		res <- edge[id,2]
		nres <- length(res)
		for( i in 1:nres ) {
			if( res[i] > ntips ) {
				res <- c(res, getDescendents(res[i],edge, ntips))
			}
		}
	}
        res
}

descendents <- function(y, tree=tree, sorting=TRUE) {
# y: tip+node labels (character vector)
# tree: a phylo class whose edge component is used
# outputs tip+node labels (character vector) sorted by default
	edge <- tree$edge
	all.label <- c(tree$tip.label, tree$node.label)
	ntips <- length(tree$tip.label)
	ID <- getDescendents( match( y, all.label ), edge, ntips )
	if( ID[1] == 0 ) {
		NA
	} else {
		res <- all.label[ID]
		if( sorting ) res <- sort(res)
		res
	}
}

parent <- function(x, edge=edge) {
# x: tip+node ID (integer vector)
# outputs tip+node ID of the immediate parent of x
	XD <- which( edge[,2] == x )
	if( length(XD) == 0 ) {
		NA
	} else {
		edge[ XD, 1]
	}
}

ancestor <- function(z, tree=tree, n=2) {
# z: tip+node label (character vector)
# output node label (character vector)
# n: n-th ancestor (1: father, 2: grandfather, 3: grand-grandfather and so on)
	edge <- tree$edge
	all.label <- c(tree$tip.label, tree$node.label)
	x <- match(z, all.label)
	for( i in 1:n ) {
		y <- parent( x, edge)
		if( is.na(y) ) {
			y <- x
			break
		} else {
			x <- y
		}
	}
	all.label[y]
}

relatives <- function(z, tree=tree, n=1, sorting=TRUE) {
# z: tip+node label (character vector)
# n: descendents of the n-th ancestor to be sought
# outputs tip+node labels including self (character vector) sorted by default
	anc <- ancestor(z,tree,n)
	res <- c(anc, descendents( anc, tree ))
	if( sorting ) res <- sort(res)
	res
}

# Reads in lower triangle distance matrix
# Returns a dist object
readDist <- function(x) {
  dst <- scan(x, what='character')
  nseq <- as.numeric(dst[1])
  message( paste('Number of data items', nseq))
  distvect <- rep(NA, nseq*(nseq-1)/2 )
  datanames <- rep('', nseq)
  k <- 1
  n <- 0
  for( i in 1:nseq ) {
    for( j in 1:i ) {
      k <- k + 1
      if( j == 1 ) {
        datanames[i] <- dst[k]
      } else {
        n <- n + 1
        distvect[n] <- as.numeric(dst[k])
      }
    }
  }
  attr(distvect, "Labels") <- datanames
  attr(distvect, "Size") <- nseq
  attr(distvect, "Diag") <- FALSE
  attr(distvect, "Upper") <- FALSE
  class(distvect) <- "dist"
  distvect
}
