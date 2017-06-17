From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Date: Sat, 17 Jun 2017 09:25:03 -0700
Message-ID: <CALCETrU1Hg=q4cdQDex--3nVBfwRC1o=9pC6Ss77Z8Lxg7ZJLg@mail.gmail.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149766213493.22552.4057048843646200083.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 16, 2017 at 6:15 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> To date, the full promise of byte-addressable access to persistent
> memory has only been half realized via the filesystem-dax interface. The
> current filesystem-dax mechanism allows an application to consume (read)
> data from persistent storage at byte-size granularity, bypassing the
> full page reads required by traditional storage devices.
>
> Now, for writes, applications still need to contend with
> page-granularity dirtying and flushing semantics as well as filesystem
> coordination for metadata updates after any mmap write. The current
> situation precludes use cases that leverage byte-granularity / in-place
> updates to persistent media.
>
> To get around this limitation there are some specialized applications
> that are using the device-dax interface to bypass the overhead and
> data-safety problems of the current filesystem-dax mmap-write path.
> QEMU-KVM is forced to use device-dax to safely pass through persistent
> memory to a guest [1]. Some specialized databases are using device-dax
> for byte-granularity writes. Outside of those cases, device-dax is
> difficult for general purpose persistent memory applications to consume.
> There is demand for access to pmem without needing to contend with
> special device configuration and other device-dax limitations.
>
> The 'daxfile' interface satisfies this demand and realizes one of Dave
> Chinner's ideas for allowing pmem applications to safely bypass
> fsync/msync requirements. The idea is to make the file immutable with
> respect to the offset-to-block mappings for every extent in the file
> [2]. It turns out that filesystems already need to make this guarantee
> today. This property is needed for files marked as swap files.
>
> The new daxctl() syscall manages setting a file into 'static-dax' mode
> whereby it arranges for the file to be treated as a swapfile as far as
> the filesystem is concerned, but not registered with the core-mm as
> swapfile space. A file in this mode is then safe to be mapped and
> written without the requirement to fsync/msync the writes.  The cpu
> cache management for flushing data to persistence can be handled
> completely in userspace.

Can you remind those of us who haven't played with DAX in a while what
the problem is with mmapping a DAX file without this patchset?  If
there's some bookkkeeping needed to make sure that the filesystem will
invalidate all the mappings if it decides to move the file, maybe that
should be the default rather than needing a new syscall.

--Andy
