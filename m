From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Date: Tue, 2 Oct 2018 17:07:08 +0200
Message-ID: <20181002150708.GF9127@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181002143713.GA19845-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 02-10-18 07:37:13, Christoph Hellwig wrote:
> On Tue, Oct 02, 2018 at 04:29:59PM +0200, Jan Kara wrote:
> > > OK naive question from me, how do we want an application to be able to
> > > check if it is running on a DAX mapping?
> > 
> > The question from me is: Should application really care?
> 
> No, it should not.  DAX is an implementation detail thay may change
> or go away at any time.

I agree that whether / how pagecache is used for filesystem access is an
implementation detail of the kernel.  OTOH for some workloads it is about
whether kernel needs gigabytes of RAM to cache files or not, which is not a
detail anymore if you want to fully utilize the machine. So people will be
asking for this and will be finding odd ways to determine whether DAX is
used or not (such as poking in smaps). And once there is some widely enough
used application doing this, it is not "stupid application" problem anymore
but the kernel's problem of not maintaining backward compatibility.

So I think we would be better off providing *some* API which applications
can use to determine whether pagecache is used or not and make sure this
API will convey the right information even if we change DAX
implementation or remove it altogether.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
