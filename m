From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Date: Wed, 3 Oct 2018 14:13:59 -0700
Message-ID: <CAPcyv4iCXNYTSzwU5OoZc_b+xxbqKwjyQV74CRxEfvDjaMPDfg@mail.gmail.com>
References: <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
 <20181002144412.GC4963@linux-x5ow.site> <20181002145206.GA10903@infradead.org>
 <20181002153100.GG9127@quack2.suse.cz>
 <CAPcyv4j0tTD+rENqFExA68aw=-MmtCBaOe1qJovyrmJC=yBg-Q@mail.gmail.com>
 <20181003125056.GA21043@quack2.suse.cz>
 <CAPcyv4jfV10yuTiPg6ijsPRRL2-c_48ovfpU5TK1Zu7BWnfk3g@mail.gmail.com>
 <20181003150658.GC24030@quack2.suse.cz>
 <CAPcyv4iJvN6_Cf6tw=5a=Uh99LfMFKU7n8QkGcz1ZaxL0Oi-3w@mail.gmail.com>
 <20181003164407.GK24030@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181003164407.GK24030-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 3, 2018 at 9:46 AM Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
>
> On Wed 03-10-18 08:13:37, Dan Williams wrote:
> > On Wed, Oct 3, 2018 at 8:07 AM Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> > > WRT per-inode DAX property, AFAIU that inode flag is just going to be
> > > advisory thing - i.e., use DAX if possible. If you mount a filesystem with
> > > these inode flags set in a configuration which does not allow DAX to be
> > > used, you will still be able to access such inodes but the access will use
> > > page cache instead. And querying these flags should better show real
> > > on-disk status and not just whether DAX is used as that would result in an
> > > even bigger mess. So this feature seems to be somewhat orthogonal to the
> > > API I'm looking for.
> >
> > True, I imagine once we have that flag we will be able to distinguish
> > the "saved" property and the "effective / live" property of DAX...
> > Also it's really not DAX that applications care about as much as "is
> > there page-cache indirection / overhead for this mapping?". That seems
> > to be a narrower guarantee that we can make than what "DAX" might
> > imply.
>
> Right. So what do people think about my suggestion earlier in the thread to
> use madvise(MADV_DIRECT_ACCESS) for this? Currently it would return success
> when DAX is in use, failure otherwise. Later we could extend it to be also
> used as a hint for caching policy for the inode...

The only problem is that you can't use it purely as a query. If we
ever did plumb it to be a hint you could not read the state without
writing the state.

mincore(2) seems to be close the intent of discovering whether RAM is
being consumed for a given address range, but it currently is
implemented to only indicate if *any* mapping is established, not
whether RAM is consumed. I can see an argument that a dax mapped file
should always report an empty mincore vector.
