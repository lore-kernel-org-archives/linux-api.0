From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v8 2/2] mm: introduce MAP_SHARED_VALIDATE, a mechanism
 to safely define new mmap flags
Date: Mon, 11 Sep 2017 10:21:36 -0700
Message-ID: <CAA9_cmfeMSUSh1FkdC=RW9jo1-e5sj5V+n6g99NOirukkWw=MA@mail.gmail.com>
References: <150489930202.29460.5141541423730649272.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150489931339.29460.8760855724603300792.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170911094714.GD8503@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170911094714.GD8503-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 11, 2017 at 2:47 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Fri 08-09-17 12:35:13, Dan Williams wrote:
>> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
>> unknown flags. However, proposals like MAP_SYNC and MAP_DIRECT need a
>> mechanism to define new behavior that is known to fail on older kernels
>> without the support. Define a new MAP_SHARED_VALIDATE flag pattern that
>> is guaranteed to fail on all legacy mmap implementations.
>>
>> With this in place new flags can be defined as:
>>
>>     #define MAP_new (MAP_SHARED_VALIDATE | val)
>
> Is this changelog stale? Given MAP_SHARED_VALIDATE will be new mapping
> type, I'd expect we define new flags just as any other mapping flags...
> I see no reason why MAP_SHARED_VALIDATE should be or'ed to that.

True, it will just by a new MAP_TYPE plus new flags. I will fix this up comment.

[..]
>> diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
>> index 3b26cc62dadb..c32276c4196a 100644
>> --- a/arch/alpha/include/uapi/asm/mman.h
>> +++ b/arch/alpha/include/uapi/asm/mman.h
>> @@ -14,6 +14,7 @@
>>  #define MAP_TYPE     0x0f            /* Mask for type of mapping (OSF/1 is _wrong_) */
>>  #define MAP_FIXED    0x100           /* Interpret addr exactly */
>>  #define MAP_ANONYMOUS        0x10            /* don't use a file */
>> +#define MAP_SHARED_VALIDATE (MAP_SHARED|MAP_PRIVATE) /* validate extension flags */
>
> And I'd explicitely define MAP_SHARED_VALIDATE as the first unused value
> among mapping types (which is in fact enum embedded inside mapping flags).
> I.e. 0x03 on alpha, x86, and probably all other archs - it has nothing to
> do with MAP_SHARED|MAP_PRIVATE - it is just another type of the mapping
> which happens to have most of the MAP_SHARED semantics...

Ok, I'll make it 0x3 everywhere.
