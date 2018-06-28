From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Date: Wed, 27 Jun 2018 19:37:01 -0700
Message-ID: <CA+55aFxs7Cc30fCiENw0R+XDJhUJ-w=z=NLLzYfT5gF2Qh-60Q@mail.gmail.com>
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
 <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c-+82itfer+wXR7s880joybQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>
Cc: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, zhibli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jun 27, 2018 at 7:17 PM Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org> wrote:
>
> What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
> whereas before it rightly returned -EINVAL.

You're still confusing *behavior* with breakage.

Yes. New *behavior* is that MAP_SHARED|MAP_PRIVATE is now a valid
thing. It means "MAP_SHARED_VALIDATE".

Behavior changed.  That's normal. Every single time we add a system
call, behavior changes: a system call that used to return -ENOSYS now
returns something else.

That's not breakage, that's just intentional new behavior.

> What behavior should a user expect from a successful mmap(MAP_SHARED|MAP_PRIVATE)?

MAP_SHARED|MAP_PRIVATE makes no sense and nobody uses it (because it
has always returned an error and never done anything interesting).

Nobody uses it, and it used to return an error is *exactly* why it was
defined to be MAP_SHARED_VALIDATE.

So you should expect MAP_SHARED_VALIDATE behavior - which is
MAP_SHARED together with "validate that all the flags are things that
we support".

Actual BREAKAGE is if some application or user workflow no longer
works. Did LibreOffice stop working? That is breakage.

And by application, I mean exactly that: a real program.  Not some
manual-page, and not some test-program that people don't actually rely
on, and that just reports on some particular behavior.

Because I can write a test program that verifies that system call #335
doesn't exist:

    #define _GNU_SOURCE
    #include <unistd.h>
    #include <sys/syscall.h>
    #include <errno.h>
    #include <assert.h>

    int main(int argc, char **argv)
    {
        assert(syscall(335, 0) == -1 && errno == ENOSYS);
        return 0;
    }

and the next system call we add will break that test program on x86-64.

And that's still not a "regression" - it's just a change in behavior.

But if firefox no longer runs, because it depended on that system call
not existing (or it depended on that MAP_SHARED_VALIDATE returning
EINVAL) then it's a regression.

See the difference?

One case is "we added new behavior".

The other case is "we have a regression".

                Linus
