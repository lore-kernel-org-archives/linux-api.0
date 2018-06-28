From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Date: Wed, 27 Jun 2018 19:10:51 -0700
Message-ID: <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <60052659-7b37-cb69-bf9f-1683caa46219-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zhibli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 27, 2018 at 6:45 PM Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Thus the invalid flag combination of (MAP_SHARED|MAP_PRIVATE) now
> passes without error, which is a regression.

It's not a regression, it's just new behavior.

"regression" doesn't mean "things changed". It means "something broke".

What broke?

Because if it's some manual page breakage, just fix the manual. That's
what "new behavior" is all about.

There is nothing that says that "MAP_SHARED_VALIDATE" can't work with
just the legacy flags.

Because I'd be worried about your patch breaking some actual new user
of MAP_SHARED_VALIDATE.

Because it's actual *users* of behavior we care about, not some
test-suite or manual pages.

              Linus
