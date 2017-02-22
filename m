From: Pavel Emelyanov <xemul@virtuozzo.com>
Subject: Re: [RFC 1/3] procfs: fdinfo -- Extend information about epoll target
 files
Date: Wed, 22 Feb 2017 11:09:23 +0300
Message-ID: <58AD4733.5060304@virtuozzo.com>
References: <20170221171254.954209904@openvz.org>
 <CALCETrUJcMuLpcLf5iQurGCnA1hqVH5YtHAq+=f81PF1OZy1Fg@mail.gmail.com>
 <20170221191655.GC27653@uranus> <58AD4147.20801@virtuozzo.com>
 <20170222075438.GB22938@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170222075438.GB22938@uranus>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linuxfoundation.org>, Andrew Vagin <avagin@virtuozzo.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kirill Kolyshkin <kir@openvz.org>, Jason Baron <jbaron@akamai.com>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

On 02/22/2017 10:54 AM, Cyrill Gorcunov wrote:
> On Wed, Feb 22, 2017 at 10:44:07AM +0300, Pavel Emelyanov wrote:
>> On 02/21/2017 10:16 PM, Cyrill Gorcunov wrote:
>>> On Tue, Feb 21, 2017 at 10:41:12AM -0800, Andy Lutomirski wrote:
>>>>> Thus lets add file position, inode and device number where
>>>>> this target lays. This three fields can be used as a primary
>>>>> key for sorting, and together with kcmp help CRIU can find
>>>>> out an exact file target (from the whole set of processes
>>>>> being checkpointed).
>>>>
>>>> I have no problem with this, but I'm wondering whether kcmp's ordered
>>>> comparisons could also be used for this purpose.
>>>
>>> Yes it can, but it would increas number of kcmp calls signisicantly.
>>
>> Actually it shouldn't. If you extend the kcmp argument to accept the
>> epollfd:epollslot pair, this would be effectively the same as if you
>> had all your epoll-ed files injected into your fdtable with "strange"
>> fd numbers. We already have two-level rbtree for this in criu, adding
>> extended ("strange") fd to it should be OK.
> 
> Nope. Pavel, I guess you forget how we handle file tree in criu currently.
> We call for kcmp only if we have to -- when primary key for two entries
> is the same.

True, but the latter is an optimization to reduce the number of syscalls.

Look, in order to have a primary key you need to do some system call for the
fd you check (read from proc or stat the descriptor). But for target files in
e-polls you don't make this per-fd syscall to get primary key, just call the
kcmp instead.

-- Pavel
