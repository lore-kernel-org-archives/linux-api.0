From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH v9 0/11] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Thu, 22 Jan 2015 17:52:21 +0900
Message-ID: <003901d03620$bbf4a450$33ddecf0$@samsung.com>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
	<CAHO5Pa3HnzP=KcBQOWDEkBqppMGXJ2kzfNKj21ruQ5SvWnms2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-reply-to: <CAHO5Pa3HnzP=KcBQOWDEkBqppMGXJ2kzfNKj21ruQ5SvWnms2g@mail.gmail.com>
Content-language: ko
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 'Michael Kerrisk' <mtk.manpages@gmail.com>
Cc: 'Namjae Jeon' <linkinjeon@gmail.com>, 'Theodore Ts'o' <tytso@mit.edu>, 'Linux API' <linux-api@vger.kernel.org>, bfoster@redhat.com, 'Linux Kernel' <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, a.sangwan@samsung.com, 'Linux-Fsdevel' <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> [CC += linux-api]
> 
> Hello Namjae
> 
> Please, all patches such as this that touch the user-space ABI must CC
> linux-api@. (The kernel source file Documentation/SubmitChecklist
> notes that all Linux kernel patches that change userspace interfaces
> should be CCed to linux-api@vger.kernel.org.  See also
> https://www.kernel.org/doc/man-pages/linux-api-ml.html )
Hi Michael,

I will keep that in mind.
Thank you!

> 
> Thanks,
> 
> Michael
> 
> 
> On Wed, Jan 21, 2015 at 4:11 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > In continuation of the work of making the process of non linear editing of
> > media files faster, we introduce here the new flag FALLOC_FL_INSERT_RANGE
> > for fallocate.
> >
> > This flag will work opposite to the FALLOC_FL_COLLAPSE_RANGE flag.
> > As such, specifying FALLOC_FL_INSERT_RANGE flag will create new space inside file
> > by inserting a hole within the range specified by offset and len.
> > User can write new data in this space. e.g. ads.
> > Like collapse range, currently we have the limitation that offset and len should
> > be block size aligned for both XFS and Ext4.
> >
> > The semantics of the flag are :
> > 1) It creates space within file by inserting a hole of  len bytes starting
> >    at offset byte without overwriting any existing data. All the data blocks
> >    from offset to EOF are shifted towards right to make hole space.
> > 2) It should be used exclusively. No other fallocate flag in combination.
> > 3) Offset and length supplied to fallocate should be fs block size aligned
> >    in case of xfs and ext4.
> > 4) Insert range does not work for the case when offset is overlapping/beyond
> >    i_size. If the user wants to insert space at the end of file they are
> >    advised to use either ftruncate(2) or fallocate(2) with mode 0.
> > 5) It increses the size of file by len bytes.
> >
> >
> > Namjae Jeon (11):
> >  fs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfs: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate
> >  xfsprogs: xfs_io: add finsert command for insert range via fallocate
> >  xfstests: generic/039: Standard insert range tests
> >  xfstests: generic/040: Delayed allocation insert range
> >  xfstests: generic/041: Multi insert range tests
> >  xfstests: generic/042: Delayed allocation multi insert
> >  xfstests: generic/043: Test multiple fallocate insert/collapse range calls
> >  xfstests: fsstress: Add fallocate insert range operation
> >  xfstests: fsx: Add fallocate insert range operation
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> --
> Michael Kerrisk Linux man-pages maintainer;
> http://www.kernel.org/doc/man-pages/
> Author of "The Linux Programming Interface", http://blog.man7.org/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
