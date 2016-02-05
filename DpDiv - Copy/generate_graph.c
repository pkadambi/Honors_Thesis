#include "mex.h"

/************************************************************************************/
/* DoMST: Miminum Spanning Tree														*/
/* This function determines the MST, and returns its length (MSTLength) and			*/
/* the list of edge connections (MSTEdges). The input, DistanceMatrix, is a			*/
/* square matrix whose elements contain the edge weights between any two nodes:		*/
/* DistanceMatrix(i,j) = edge weight between node i and node j. A commonly			*/
/* used edge weight is the Euclidean distance between node i and node j. This		*/
/* function runs in O(nNodes^2) time, where nNodes = number of nodes in graph. The	*/
/* algorithm is based on Whitney, Communications of the ACM (15) 273, April 1972.	*/
/************************************************************************************/
void DoMST( double **dmatrix, double **ematrix, int nNodes, double *MSTLength )
{
	/* declare variables */
    int i,IndexOfNodeToAdd,NodeToAdd,nNotInMST;
    int *MSTClosestNodes,*NodesNotInMST;
    double *MSTCheapestEdges, CheapestEdge;
	double **DistanceMatrix;
	double **MSTEdges;
	
    DistanceMatrix = dmatrix;
	MSTEdges = ematrix;

	/* malloc space */
    MSTClosestNodes = ( int * )malloc( ( nNodes ) * sizeof( int ) );
    if ( !MSTClosestNodes ) 
	{
		printf( "malloc failed in DoMST()\n ");
		exit( EXIT_FAILURE );
	}

    NodesNotInMST = ( int * )malloc( ( nNodes ) * sizeof( int ) );
    if ( !NodesNotInMST ) 
	{
		printf( "malloc failed in DoMST()\n ");
		exit( EXIT_FAILURE );
    }

    MSTCheapestEdges = ( double * )malloc( ( nNodes ) * sizeof( double ) );
    if ( !MSTCheapestEdges ) 
	{
		printf( "malloc failed in DoMST()\n ");
		exit( EXIT_FAILURE );
    }

	/* initialize variables */
    NodeToAdd = nNodes - 1;	/* node to be added to tree - start with last node */
    nNotInMST = nNodes - 1; /* number of nodes not yet in tree - should end at nNotInMST = 0 */
    *MSTLength = 0.0;		

    for( i = 0; i < nNotInMST; i++ )
    {
		NodesNotInMST[i] = i;								/* array of nodes not yet in tree */
		MSTClosestNodes[i] = NodeToAdd;						/* node of partial tree closest to node NodesNotInMST(i) */
		MSTCheapestEdges[i] = *( *DistanceMatrix + nNodes*i + NodeToAdd );	/* edge weight from NodesNotInMST(i) to MSTClosestNodes(i) */
	}

	/* Form MST one node at a time, keep adding nodes until all are on MST */
    while( nNotInMST > 0 )
    {
		/* update labels of nodes not yet in tree */
		for( i = 0; i < nNotInMST; i++ )
		{
			if( MSTCheapestEdges[i] > *( *DistanceMatrix + nNodes*NodesNotInMST[i] + NodeToAdd ) )
			{
				MSTClosestNodes[i] = NodeToAdd;
				MSTCheapestEdges[i] = *( *DistanceMatrix + nNodes*NodesNotInMST[i] + NodeToAdd );
			}
		}

		/* find node outside tree nearest to tree */
		CheapestEdge = MSTCheapestEdges[0];			/* initialize lowest edge weight CheapestEdge to first edge */
		for( i = 0; i < nNotInMST; i++ )
		{
			if( MSTCheapestEdges[i] <= CheapestEdge )
			{
				CheapestEdge = MSTCheapestEdges[i]; /* current best edge weight to add */
				IndexOfNodeToAdd = i;				/* current best node to add */
			}
		}

		/* put nodes of appropriate edge into array MSTEdges */
		NodeToAdd = NodesNotInMST[IndexOfNodeToAdd];
		*( *MSTEdges + ( nNodes - nNotInMST - 1 ) + 0 ) = NodeToAdd + 1; /* add 1 to get back to MATLAB indexing */
		*( *MSTEdges + ( nNodes - nNotInMST - 1 ) + nNodes - 1 ) = MSTClosestNodes[IndexOfNodeToAdd] + 1; /* add 1 to get back to MATLAB indexing */
		*MSTLength += CheapestEdge;

		/* Remove newly found MST node from array NodesNotInMST by replacing it with the last node in NodesNotInMST, then decrement the number of nodes not yet in the tree */
		MSTCheapestEdges[IndexOfNodeToAdd] = MSTCheapestEdges[nNotInMST - 1];
		NodesNotInMST[IndexOfNodeToAdd] = NodesNotInMST[nNotInMST - 1];
		MSTClosestNodes[IndexOfNodeToAdd] = MSTClosestNodes[nNotInMST - 1];
		nNotInMST--;

    }

	/* free malloced memory */
    free( MSTClosestNodes );
    free( NodesNotInMST );
    free( MSTCheapestEdges );

}
/************************************************************************************/


/************************************************************************************/
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] )
{
	double *length;
	double *dmatrix, *ematrix;
	int n;	

	/* check on number of parameters passed */
	if( nrhs != 1 ) 
	{
		mexErrMsgTxt( "One input required." );
	} else if( nlhs != 2 ) 
	{
		mexErrMsgTxt( "Two outputs required." );
	}

	dmatrix = mxGetPr( prhs[0] );						/* matrix of edge weights */

	n = mxGetN( prhs[0] ); 								/* number of nodes */

	plhs[0] = mxCreateDoubleMatrix( 1, 1, mxREAL );		/* scalar MST length */
	length = mxGetPr( plhs[0] ); 

    plhs[1] = mxCreateDoubleMatrix( n-1, 2, mxREAL );	/* matrix of edge connections */
	ematrix = (double *)mxGetPr( plhs[1] );				/* yes this should be type int but have mx annoyances in that case */
	
    DoMST( &dmatrix, &ematrix, n, length );
}
/************************************************************************************/