From: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Date: Wed, 27 Jun 2018 21:17:55 -0500
Message-ID: <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zhibli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 6/27/18 9:10 PM, Linus Torvalds wrote:
> On Wed, Jun 27, 2018 at 6:45 PM Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Thus the invalid flag combination of (MAP_SHARED|MAP_PRIVATE) now
>> passes without error, which is a regression.
> 
> It's not a regression, it's just new behavior.
> 
> "regression" doesn't mean "things changed". It means "something broke".
> 
> What broke?

My commit log perhaps was not clear enough.

What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
whereas before it rightly returned -EINVAL.

What behavior should a user expect from a successful mmap(MAP_SHARED|MAP_PRIVATE)?

-Eric

> Because if it's some manual page breakage, just fix the manual. That's
> what "new behavior" is all about.
> 
> There is nothing that says that "MAP_SHARED_VALIDATE" can't work with
> just the legacy flags.
> 
> Because I'd be worried about your patch breaking some actual new user
> of MAP_SHARED_VALIDATE.
> 
> Because it's actual *users* of behavior we care about, not some
> test-suite or manual pages.
> 
>               Linus
