From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Date: Tue, 2 Oct 2018 16:29:59 +0200
Message-ID: <20181002142959.GD9127@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181002121039.GA3274-qw2SdCWA0PpjqqEj2zc+bA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[Added ext4, xfs, and linux-api folks to CC for the interface discussion]

On Tue 02-10-18 14:10:39, Johannes Thumshirn wrote:
> On Tue, Oct 02, 2018 at 12:05:31PM +0200, Jan Kara wrote:
> > Hello,
> > 
> > commit e1fb4a086495 "dax: remove VM_MIXEDMAP for fsdax and device dax" has
> > removed VM_MIXEDMAP flag from DAX VMAs. Now our testing shows that in the
> > mean time certain customer of ours started poking into /proc/<pid>/smaps
> > and looks at VMA flags there and if VM_MIXEDMAP is missing among the VMA
> > flags, the application just fails to start complaining that DAX support is
> > missing in the kernel. The question now is how do we go about this?
> 
> OK naive question from me, how do we want an application to be able to
> check if it is running on a DAX mapping?

The question from me is: Should application really care? After all DAX is
just a caching decision. Sure it affects performance characteristics and
memory usage of the kernel but it is not a correctness issue (in particular
we took care for MAP_SYNC to return EOPNOTSUPP if the feature cannot be
supported for current mapping). And in the future the details of what we do
with DAX mapping can change - e.g. I could imagine we might decide to cache
writes in DRAM but do direct PMEM access on reads. And all this could be
auto-tuned based on media properties. And we don't want to tie our hands by
specifying too narrowly how the kernel is going to behave.

OTOH I understand that e.g. for a large database application the difference
between DAX and non-DAX mapping can be a difference between performs fine
and performs terribly / kills the machine so such application might want to
determine / force caching policy to save sysadmin from debugging why the
application is misbehaving.

> AFAIU DAX is always associated with a file descriptor of some kind (be
> it a real file with filesystem dax or the /dev/dax device file for
> device dax). So could a new fcntl() be of any help here? IS_DAX() only
> checks for the S_DAX flag in inode::i_flags, so this should be doable
> for both fsdax and devdax.

So fcntl() to query DAX usage is one option. Another option is the GETFLAGS
ioctl with which you can query the state of S_DAX flag (works only for XFS
currently). But that inode flag was meant more as a hint "use DAX if
available" AFAIK so that's probably not really suitable for querying
whether DAX is really in use or not. Since DAX is really about caching
policy, I was also thinking that we could use madvise / fadvise for this.
I.e., something like MADV_DIRECT_ACCESS which would return with success if
DAX is in use, with error if not. Later, kernel could use it as a hint to
really force DAX on a mapping and not try clever caching policies...
Thoughts?

								Honza

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
