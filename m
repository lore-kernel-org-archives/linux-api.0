From: Nicolas Belouin <nicolas@belouin.fr>
Subject: Re: [PATCH] fs: Use CAP_DAC_OVERRIDE to allow for file dedupe
Date: Sat, 21 Oct 2017 21:40:14 +0200
Message-ID: <A9CEA82D-DEC7-4F4F-AF16-68CFF5DA203A@belouin.fr>
References: <20171021132806.18086-1-nicolas@belouin.fr> <CAFJ0LnGjhjm9iswxh-naLM9qZq-fQ_a0MdyVDsmRUk4ME0xuNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-10235-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAFJ0LnGjhjm9iswxh-naLM9qZq-fQ_a0MdyVDsmRUk4ME0xuNA@mail.gmail.com>
To: Nick Kralevich <nnk@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org



On October 21, 2017 4:08:31 PM GMT+02:00, Nick Kralevich <nnk@google=2Ecom=
> wrote:
>On Sat, Oct 21, 2017 at 6:28 AM, Nicolas Belouin <nicolas@belouin=2Efr>
>wrote:
>> In its current implementation the check is against CAP_SYS_ADMIN,
>> however this capability is bloated and inapropriate for this use=2E
>> Indeed the check aims to avoid dedupe against non writable files,
>> falling directly in the use case of CAP_DAC_OVERRIDE=2E
>>
>> Signed-off-by: Nicolas Belouin <nicolas@belouin=2Efr>
>> ---
>>  fs/read_write=2Ec | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/read_write=2Ec b/fs/read_write=2Ec
>> index f0d4b16873e8=2E=2E43cc7e84e29e 100644
>> --- a/fs/read_write=2Ec
>> +++ b/fs/read_write=2Ec
>> @@ -1965,7 +1965,7 @@ int vfs_dedupe_file_range(struct file *file,
>struct file_dedupe_range *same)
>>         u64 len;
>>         int i;
>>         int ret;
>> -       bool is_admin =3D capable(CAP_SYS_ADMIN);
>> +       bool is_admin =3D capable(CAP_SYS_ADMIN) ||
>capable(CAP_DAC_OVERRIDE);
>
>Can you please reverse the order of the checks? In particular, on an
>SELinux based system, a capable() call generates an SELinux denial,
>and people often instinctively allow the first operation performed=2E
>Reordering the elements will ensure that the CAP_DAC_OVERRIDE denial
>(least permissive) is generated first=2E

Will do in the v2 of every concerned patch=2E

>
>>         u16 count =3D same->dest_count;
>>         struct file *dst_file;
>>         loff_t dst_off;
>> --
>> 2=2E14=2E2
>>

Nicolas
