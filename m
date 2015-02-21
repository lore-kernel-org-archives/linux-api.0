From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v10 0/12] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Sun, 22 Feb 2015 00:45:42 +0900
Message-ID: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: david@fromorbit.com, tytso@mit.edu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, bfoster@redhat.com, mtk.manpages@gmail.com, linux-man@vger.kernel.org, linux-api@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
List-Id: linux-api@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In continuation of the work of making the process of non linear editing of
media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
for fallocate.

This flag will work opposite to the FALLOC_FL_COLLAPSE_RANGE flag.
As such, specifying FALLOC_FL_INSERT_RANGE flag will create new space inside file
by inserting a hole within the range specified by offset and len. 
User can write new data in this space. e.g. ads.
Like collapse range, currently we have the limitation that offset and len should
be block size aligned for both XFS and Ext4.

The semantics of the flag are :
1) It creates space within file by inserting a hole of  len bytes starting
   at offset byte without overwriting any existing data. All the data blocks
   from offset to EOF are shifted towards right to make hole space.
2) It should be used exclusively. No other fallocate flag in combination.
3) Offset and length supplied to fallocate should be fs block size aligned
   in case of xfs and ext4.
4) Insert range does not work for the case when offset is overlapping/beyond
   i_size. If the user wants to insert space at the end of file they are
   advised to use either ftruncate(2) or fallocate(2) with mode 0.
5) It increses the size of file by len bytes.


Namjae Jeon (12):
 fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
 ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
 xfsprog: xfsio: update xfs_io manpage for FALLOC_FL_INSERT_RANGE
 xfstests: generic/042: Standard insert range tests
 xfstests: generic/043: Delayed allocation insert range
 xfstests: generic/044: Multi insert range tests
 xfstests: generic/045: Delayed allocation multi insert
 xfstests: generic/046: Test multiple fallocate insert/collapse range calls
 xfstests: fsstress: Add fallocate insert range operation
 xfstests: fsx: Add fallocate insert range operation
 manpage: update FALLOC_FL_INSERT_RANGE flag in fallocate
-- 
1.7.9.5
