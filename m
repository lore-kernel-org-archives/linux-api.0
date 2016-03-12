From: Thomas Schoebel-Theuer <tst-0Nly+W1lFbFDiq0p6IFu4YQuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Sat, 12 Mar 2016 11:11:38 +0100
Message-ID: <56E3EB5A.2040208@schoebel-theuer.de>
References: <56E18B9B.5070503@gmail.com>
 <CA+55aFyw1nN4ze3-AGGE27evOZuXnkJC9C-W5QRUR=zKHqObGg@mail.gmail.com>
 <56E24CA5.3030702@redhat.com> <20160311135952.57a44931@lxorguk.ukuu.org.uk>
 <CA+55aFwX2GYYN53E9qaTym=gp1aRjSA5f1G+N5WEiRd1dOJhFA@mail.gmail.com>
 <CALCETrX5Hr6=yWPrNrh2u3YZNYmmv5ZdOQXcgNX5xr54N+Cfvw@mail.gmail.com>
 <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
 <20160311223047.GZ30721@dastard> <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160312071945.GA3419@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160312071945.GA3419-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/12/2016 08:19 AM, Theodore Ts'o wrote:
> On Fri, Mar 11, 2016 at 04:44:16PM -0800, Linus Torvalds wrote:
>>
>> There's a big difference between "give the user rope", and "tie the
>> rope in a noose and put a banana peel so that the user might stumble
>> into the rope and hang himself", though.
> [...]  And then the application has to run
> setgid with that group's privileges.

Your concept of hierarchically nesting containers via filesystem 
instances looks nice to me.

A potential concern could be whether gids are the right implementation 
for expressing hierarchically nested access permissions in a persistent way.

Your permissions attached to gids are nested (because inside of your 
containers you may have another instance of a completely different gid 
namespace), they are also persistent when your mount flags etc are 
restored properly after a crash (by some scripts), but probably use of 
gids for this might look like a kind of "misuse" of the original gid 
concept from the 1970s.

Maybe you currently don't have a better /persistent/ concept for 
expressing your needs, so maybe your solution could be just fine under 
the currently given cirumstances.

Introduction of a new concept for overcoming the current limitations 
must be done very carefully.

The bad discard semantics concerns about information leaks could be 
/hypothetically/ solved at /concept level/ in the following way. Please 
note that by "concept level" I don't want to imply any particular 
implementation, this is just a mental experiment for discussion of the 
problems,  just a "model of thinking":

a) Use a hierarchical namespace for naming subjects, e.g. 
hypervisorA.containerB.subcontainerC.user9 instead of gid=9

b) Attach actual permissions to each block of the underlying block 
device (fine-grained object model).

c) Correctly maintain access rights at each hierarchical layer, and for 
all operations (including discard with whatever semantics). In case some 
inner instance is untrusted and may do evil things, this will be 
intercepted / corrected at outer layers (which are more trusted). In 
essence, the nesting hierarchy is also a hierarchy of trust.

Now information leaks by bad discard semantics etc should be solved at 
any level, even regarding completely unrelated containers or users, as 
long as no physical access to the disk is possible. In addition, 
encryption may be used for even overcoming this.

Of course, a direct implementation of such extremely fine-grained access 
permissions would carry way too much overhead. Both the number of 
subjects as well as the number of objects must be reduced to some 
reasonable order of magnitude, at least at outer levels.

Thus the question is: how can we achieve almost the same effect with 
much less overhead?


Hmm, in my old Athomux research prototype, I proposed some solutions for 
this, on an academic green meadow. But I am unsure what is transferable 
to a standard POSIX semantics system, and what not. Rethinking these 
concepts as well as checking them may take some time....

Here is a first alpha-stage attempt:

1) Give up the hierarchical subject namespace a), but maybe not fully. 
Access checking will continue /locally/ at each layer, by treating each 
subsystem as a (grey) blackbox. This is already the default 
implementation strategy. The total system may be less secure than in an 
idealized fine-grained system, because outer levels can no longer detect 
bad guys inside of their subsystem instances. The question is: how to 
get a "more secure" system than currently, with some reasonable effort.

2) Some /coarse/ access permission checks at the block layer b), but 
finer than today. Currently there is almost no checking at all (except 
when accessing a huge block device as a whole during open() => at 1&1 we 
have very large ones, and they may continue running for years). I am 
unsure how to achieve this in detail.

An idea for a long-term solution would be offloading of "allocation 
groups" to the block layer (if their size is coarsely dynamic in 
general, e.g. in steps of gigabytes), and to implement some coarse 
permission checks there. These could then be related to "containers" or 
"container groups". One of the problems is that some wide-spread network 
protocols like iSCSI have no clue about this, so this can only be an 
optional new feature.

Further ideas sought.

Cheers, Thomas

P.S. The concept of a "nest" in Athomux was already some kind of 
"recursively nested block device".
