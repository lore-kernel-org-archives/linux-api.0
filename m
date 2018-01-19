From: Christoph Hellwig <hch@lst.de>
Subject: Re: aio fsync revisited
Date: Fri, 19 Jan 2018 20:06:09 +0100
Message-ID: <20180119190609.GA19772@lst.de>
References: <20180117194747.1631-1-hch@lst.de> <20180118224614.GI16421@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180118224614.GI16421@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 19, 2018 at 09:46:14AM +1100, Dave Chinner wrote:
> After I get back from LCA (all next week) I'll update the fsmark
> aio patches I have and retest this. The code looks pretty similar to
> the last "generic aio fsync" patch I wrote, so I'm guessing that the
> results will be pretty similar, too.

Your patch applied as-is, as that's what I've been using to test the
feature.  Howerever I needed the following fixups to actually make
the compiler and linker happy:

diff --git a/Makefile b/Makefile
index 9b75ce3..ce5f54b 100644
--- a/Makefile
+++ b/Makefile
@@ -11,13 +11,14 @@ DIR2= /test/dir2
 
 COBJS= fs_mark.o lib_timing.o
 CFLAGS= -O2 -Wall -D_FILE_OFFSET_BITS=64
+LDFLAGS= -laio
 
 all: fs_mark 
 
 fs_mark.o: fs_mark.c fs_mark.h
 
 fs_mark: fs_mark.o lib_timing.o
-	${CC} -o fs_mark fs_mark.o lib_timing.o
+	${CC} ${LDFLAGS} -o fs_mark fs_mark.o lib_timing.o
 
 test: fs_mark
 	./fs_mark -d ${DIR1} -d ${DIR2} -s 51200 -n 4096
diff --git a/fs_mark.c b/fs_mark.c
index 8f8fb84..4a4103d 100644
--- a/fs_mark.c
+++ b/fs_mark.c
@@ -135,7 +135,7 @@ get_fsync_completions(int threshold)
 		aio_flight -= r;
 		for (i = 0; i < r; ++i) {
 			if (ioevents[i].res)
-				printf("FAIL! aio_fsync returned %d\n",
+				printf("FAIL! aio_fsync returned %zd\n",
 					ioevents[i].res);
 		}
 		usleep(1000);
@@ -162,6 +162,7 @@ do_fsync(int fd)
 		cleanup_exit();
 	}
 
+	return 0;
 }
 
 /*
