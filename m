From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 8/9] vfs: copy_file_range() can do a pagecache copy
 with splice
Date: Fri, 25 Sep 2015 17:14:59 -0700
Message-ID: <CALCETrWLAwNVqAiTMOmaktVY0cQkM0bX2vztXzEHm3EFYDg6zA@mail.gmail.com>
References: <1443214096-12769-1-git-send-email-Anna.Schumaker@Netapp.com> <1443214096-12769-9-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1443214096-12769-9-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Al Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, andros@netapp.com, Christoph Hellwig <hch@infradead.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 25, 2015 at 1:48 PM, Anna Schumaker
<Anna.Schumaker@netapp.com> wrote:
> The NFS server will need some kind offallback for filesystems that don't
> have any kind of copy acceleration, and it should be generally useful to
> have an in-kernel copy to avoid lots of switches between kernel and user
> space.
>
> I make this configurable by adding two new flags.  Users who only want a
> reflink can pass COPY_FR_REFLINK, and users who want a full data copy can
> pass COPY_FR_COPY.  The default (flags=0) means to first attempt a
> reflink, but use the pagecache if that fails.
>

Can you clarify how the subject line fits in?  I'm a bit lost.

--Andy
