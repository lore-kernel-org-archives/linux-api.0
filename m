From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Date: Wed, 3 Oct 2018 14:50:56 +0200
Message-ID: <20181003125056.GA21043@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
 <20181002144412.GC4963@linux-x5ow.site>
 <20181002145206.GA10903@infradead.org>
 <20181002153100.GG9127@quack2.suse.cz>
 <CAPcyv4j0tTD+rENqFExA68aw=-MmtCBaOe1qJovyrmJC=yBg-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4j0tTD+rENqFExA68aw=-MmtCBaOe1qJovyrmJC=yBg-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 02-10-18 13:18:54, Dan Williams wrote:
> On Tue, Oct 2, 2018 at 8:32 AM Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> >
> > On Tue 02-10-18 07:52:06, Christoph Hellwig wrote:
> > > On Tue, Oct 02, 2018 at 04:44:13PM +0200, Johannes Thumshirn wrote:
> > > > On Tue, Oct 02, 2018 at 07:37:13AM -0700, Christoph Hellwig wrote:
> > > > > No, it should not.  DAX is an implementation detail thay may change
> > > > > or go away at any time.
> > > >
> > > > Well we had an issue with an application checking for dax, this is how
> > > > we landed here in the first place.
> > >
> > > So what exacty is that "DAX" they are querying about (and no, I'm not
> > > joking, nor being philosophical).
> >
> > I believe the application we are speaking about is mostly concerned about
> > the memory overhead of the page cache. Think of a machine that has ~ 1TB of
> > DRAM, the database running on it is about that size as well and they want
> > database state stored somewhere persistently - which they may want to do by
> > modifying mmaped database files if they do small updates... So they really
> > want to be able to use close to all DRAM for the DB and not leave slack
> > space for the kernel page cache to cache 1TB of database files.
> 
> VM_MIXEDMAP was never a reliable indication of DAX because it could be
> set for random other device-drivers that use vm_insert_mixed(). The
> MAP_SYNC flag positively indicates that page cache is disabled for a
> given mapping, although whether that property is due to "dax" or some
> other kernel mechanics is purely an internal detail.
> 
> I'm not opposed to faking out VM_MIXEDMAP if this broken check has
> made it into production, but again, it's unreliable.

So luckily this particular application wasn't widely deployed yet so we
will likely get away with the vendor asking customers to update to a
version not looking into smaps and parsing /proc/mounts instead.

But I don't find parsing /proc/mounts that beautiful either and I'd prefer
if we had a better interface for applications to query whether they can
avoid page cache for mmaps or not.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
