From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] mm, mincore2(): retrieve dax and tlb-size
 attributes of an address range
Date: Mon, 12 Sep 2016 10:25:23 -0700
Message-ID: <CAPcyv4i7faR5KnaSKFFHnc-=1XsTn2naWfiCjB4Mn2=womg9QA@mail.gmail.com>
References: <147361509579.17004.5258725187329709824.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAOSf1CHKY7LT0z+wpo7jUy3aYUDHCKDKwF0XoMwpKN4JwfYjeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAOSf1CHKY7LT0z+wpo7jUy3aYUDHCKDKwF0XoMwpKN4JwfYjeA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Oliver O'Halloran <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Sep 11, 2016 at 11:29 PM, Oliver O'Halloran <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Sep 12, 2016 at 3:31 AM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> As evidenced by this bug report [1], userspace libraries are interested
>> in whether a mapping is DAX mapped, i.e. no intervening page cache.
>> Rather than using the ambiguous VM_MIXEDMAP flag in smaps, provide an
>> explicit "is dax" indication as a new flag in the page vector populated
>> by mincore.
>>
>> There are also cases, particularly for testing and validating a
>> configuration to know the hardware mapping geometry of the pages in a
>> given process address range.  Consider filesystem-dax where a
>> configuration needs to take care to align partitions and block
>> allocations before huge page mappings might be used, or
>> anonymous-transparent-huge-pages where a process is opportunistically
>> assigned large pages.  mincore2() allows these configurations to be
>> surveyed and validated.
>>
>> The implementation takes advantage of the unused bits in the per-page
>> byte returned for each PAGE_SIZE extent of a given address range.  The
>> new format of each vector byte is:
>>
>> (TLB_SHIFT - PAGE_SHIFT) << 2 | vma_is_dax() << 1 | page_present
>
> What is userspace expected to do with the information in vec? Whether
> PMD or THP mappings can be used is going to depend more on the block
> allocations done by the filesystem rather than anything the an
> application can directly influence. Returning a vector for each page
> makes some sense in the mincore() case since the application can touch
> each page to fault them in, but I don't see what they can do here.

It's not a "can huge pages be used?" question it's interrogating the
mapping that got established after the fact.  If an
application/environment expects huge mappings, but pte mappings are
getting established

> Why not just get rid of vec entirely and make mincore2() a yes/no
> check over the range for whatever is supplied in flags? That would
> work for NVML's use case and it should be easier to extend if needed.

I think having a way to ask the kernel if an address range satisfies a
certain set of input attributes is a useful interface.  Perhaps a
"MINCORE_CHECK" flag can indicate that the input vector contains a
single character that it wants the kernel to validate during the page
table walk, and return zero or the offset of the first mismatch.
