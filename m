From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 9 Mar 2018 17:43:12 -0800
Message-ID: <64a80f5e-25db-5413-ab50-fb122bc22d8c@fb.com>
References: <20180309181527.GA15803@kroah.com>
 <E622B120-3C3A-4A15-8E1B-6F7649038623@amacapital.net>
 <74e26cc0-9e72-f03b-5396-f3480921f234@fb.com>
 <20180309.135550.385837861865623769.davem@davemloft.net>
 <CALCETrWYDfByh7=xiO9T7_fFGMwMvZxUu40bkMdO9HE3E6=1VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWYDfByh7=xiO9T7_fFGMwMvZxUu40bkMdO9HE3E6=1VQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, David Miller <davem@davemloft.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/9/18 11:37 AM, Andy Lutomirski wrote:
> On Fri, Mar 9, 2018 at 6:55 PM, David Miller <davem@davemloft.net> wrote:
>> From: Alexei Starovoitov <ast@fb.com>
>> Date: Fri, 9 Mar 2018 10:50:49 -0800
>>
>>> On 3/9/18 10:23 AM, Andy Lutomirski wrote:
>>>> It might not be totally crazy to back it by tmpfs.
>>>
>>> interesting. how do you propose to do it?
>>> Something like:
>>> - create /umh_module_tempxxx dir
>>> - mount tmpfs there
>>> - copy elf into it and exec it?
>>
>> I think the idea is that it's an internal tmpfs mount that only
>> the kernel has access too.
>
> That's what I was imagining.  There's precedent.  For example, there's
> a very short piece of code that does it in
> drivers/gpu/drm/i915/i915_gemfs.c.

I can do "monkey see monkey do" approach which will look like:
type = get_fs_type("tmpfs");
fs = kern_mount(type);

/* for each request_umh("foo") */
file = shmem_file_setup_with_mnt(fs, "umh_foo");
do {
   pagecache_write_begin(file,...);
   memcpy()
   pagecache_write_end();
} while (umh_elf_size);
do_execve_file(file);
fput(file);

while keeping fs mounted forever?
is there better way?
