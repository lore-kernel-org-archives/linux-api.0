From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [kernel-hardening] [PATCH] fs: Use CAP_DAC_OVERRIDE to allow for
 file dedupe
Date: Thu, 26 Oct 2017 00:54:42 -0700
Message-ID: <CALCETrVaAOaQgTGiTnSoRiEX4oj1BOiKdfjsd+O8-zQd_vHk4Q@mail.gmail.com>
References: <20171021132806.18086-1-nicolas@belouin.fr> <CAFJ0LnGjhjm9iswxh-naLM9qZq-fQ_a0MdyVDsmRUk4ME0xuNA@mail.gmail.com>
 <A9CEA82D-DEC7-4F4F-AF16-68CFF5DA203A@belouin.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <A9CEA82D-DEC7-4F4F-AF16-68CFF5DA203A@belouin.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Belouin <nicolas@belouin.fr>
Cc: Nick Kralevich <nnk@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 21, 2017 at 12:40 PM, Nicolas Belouin <nicolas@belouin.fr> wrote:
>
>
> On October 21, 2017 4:08:31 PM GMT+02:00, Nick Kralevich <nnk@google.com> wrote:
>>On Sat, Oct 21, 2017 at 6:28 AM, Nicolas Belouin <nicolas@belouin.fr>
>>wrote:
>>> In its current implementation the check is against CAP_SYS_ADMIN,
>>> however this capability is bloated and inapropriate for this use.
>>> Indeed the check aims to avoid dedupe against non writable files,
>>> falling directly in the use case of CAP_DAC_OVERRIDE.
>>>
>>> Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
>>> ---
>>>  fs/read_write.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/read_write.c b/fs/read_write.c
>>> index f0d4b16873e8..43cc7e84e29e 100644
>>> --- a/fs/read_write.c
>>> +++ b/fs/read_write.c
>>> @@ -1965,7 +1965,7 @@ int vfs_dedupe_file_range(struct file *file,
>>struct file_dedupe_range *same)
>>>         u64 len;
>>>         int i;
>>>         int ret;
>>> -       bool is_admin = capable(CAP_SYS_ADMIN);
>>> +       bool is_admin = capable(CAP_SYS_ADMIN) ||
>>capable(CAP_DAC_OVERRIDE);
>>
>>Can you please reverse the order of the checks? In particular, on an
>>SELinux based system, a capable() call generates an SELinux denial,
>>and people often instinctively allow the first operation performed.
>>Reordering the elements will ensure that the CAP_DAC_OVERRIDE denial
>>(least permissive) is generated first.
>
> Will do in the v2 of every concerned patch.
>

That's still a bit wrong because of how audit works.  What you really want is:

bool have_either_global_cap(int cap1, int cap2);

where, if neither cap is available, the audit message references cap1
and not cap2.  Ditto for have_either_ns_cap().

--Andy
