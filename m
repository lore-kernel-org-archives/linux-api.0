From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Possible new execveat(2) Linux syscall
Date: Fri, 21 Nov 2014 13:49:35 +0000
Message-ID: <CAHse=S9RATqvXSrFXxDOcWx7Ub94Yhyr_-=USib-PPMx+_CC-w@mail.gmail.com>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx> <20141121101318.GG8866@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141121101318.GG8866-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 10:13 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Sun, Nov 16, 2014 at 02:52:46PM -0500, Rich Felker wrote:
>> I've been following the discussions so far and everything looks mostly
>> okay. There are still issues to be resolved with the different
>> semantics between Linux O_PATH and what POSIX requires for O_EXEC (and
>> O_SEARCH) but as long as the intent is that, once O_EXEC is defined to
>> save the permissions at the time of open and cause them to be used in
>> place of the current file permissions at the time of execveat
>
> As far as I can tell we only need the little patch below to make Linux
> O_PATH a valid O_SEARCH implementation.  Rich, you said you wanted to
> look over it?
>
> For O_EXEC my interpretation is that we basically just need this new
> execveat syscall + a patch to add FMODE_EXEC and enforce it.  So we
> wouldn't even need the O_PATH|3 hack.  But unless someone more familar
> with the arcane details of the Posix language verifies it I'm tempted to
> give up trying to help to implent these flags :(

I'm not particularly familiar with POSIX details either, but I thought the
O_PATH|3 hack would be needed for the interaction with O_ACCMODE -- just
using FMODE_EXEC as O_EXEC would confuse existing code that examines
(flags & O_ACCMODE).

>From [1]:
  "Applications shall specify exactly one of the ...five ... file access
  modes ... O_EXEC / O_RDONLY / O_RDWR / O_SEARCH / O_WRONLY"
(and O_EXEC and O_SEARCH are allowed to be the same value,
as one only applies to files and the other only applies to directories).

As O_ACCMODE is 3, there are only 4 possible access modes that work
with any existing code that checks (flags & O_ACCMODE), and 3 of the
values are taken (0=O_RDONLY, 1=O_WRONLY, 2=O_RDWR).  So I
guess that's where the idea for the |3 hack comes from.

[1] http://pubs.opengroup.org/onlinepubs/9699919799/functions/open.html
