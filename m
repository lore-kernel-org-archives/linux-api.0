From: Felipe Gasper <felipe@felipegasper.com>
Subject: Re: [PATCH] Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
Date: Fri, 17 May 2019 10:11:38 -0400
Message-ID: <AF68C2F5-1E59-44D4-BC63-9C988C278174@felipegasper.com>
References: <20190517032505.19921-1-felipe@felipegasper.com>
 <CALCETrUaTamZ1ZGbWpu+4kDAEFRqyESoa_4tgwpAmMh3NVQ4pQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUaTamZ1ZGbWpu+4kDAEFRqyESoa_4tgwpAmMh3NVQ4pQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


> On May 17, 2019, at 12:59 AM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
>> On May 16, 2019, at 8:25 PM, Felipe <felipe@felipegasper.com> wrote:
>>=20
>> Author: Felipe Gasper <felipe@felipegasper.com>
>> Date:   Thu May 16 12:16:53 2019 -0500
>>=20
>>   Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
>>=20
>>   This adds the ability for Netlink to report a socket=E2=80=99s UID =
along with the
>>   other UNIX socket diagnostic information that is already available. =
This will
>>   allow diagnostic tools greater insight into which users control =
which socket.
>>=20
>>   Signed-off-by: Felipe Gasper <felipe@felipegasper.com>
>>=20
>> diff --git a/include/uapi/linux/unix_diag.h =
b/include/uapi/linux/unix_diag.h
>> index 5c502fd..a198857 100644
>> --- a/include/uapi/linux/unix_diag.h
>> +++ b/include/uapi/linux/unix_diag.h
>> @@ -20,6 +20,7 @@ struct unix_diag_req {
>> #define UDIAG_SHOW_ICONS    0x00000008    /* show pending connections =
*/
>> #define UDIAG_SHOW_RQLEN    0x00000010    /* show skb receive queue =
len */
>> #define UDIAG_SHOW_MEMINFO    0x00000020    /* show memory info of a =
socket */
>> +#define UDIAG_SHOW_UID        0x00000040    /* show socket's UID */
>>=20
>> struct unix_diag_msg {
>>   __u8    udiag_family;
>> @@ -40,6 +41,7 @@ enum {
>>   UNIX_DIAG_RQLEN,
>>   UNIX_DIAG_MEMINFO,
>>   UNIX_DIAG_SHUTDOWN,
>> +    UNIX_DIAG_UID,
>>=20
>>   __UNIX_DIAG_MAX,
>> };
>> diff --git a/net/unix/diag.c b/net/unix/diag.c
>> index 3183d9b..011f56c 100644
>> --- a/net/unix/diag.c
>> +++ b/net/unix/diag.c
>> @@ -110,6 +110,11 @@ static int sk_diag_show_rqlen(struct sock *sk, =
struct sk_buff *nlskb)
>>   return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
>> }
>>=20
>> +static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
>> +{
>> +    return nla_put(nlskb, UNIX_DIAG_UID, sizeof(kuid_t), =
&(sk->sk_uid));
>=20
> That type is called *k* uid_t because it=E2=80=99s internal to the =
kernel. You
> probably want from_kuid_munged(), which will fix it up for an
> appropriate userns.  Presumably you want sk=E2=80=99s netns=E2=80=99s =
userns.

Thank you for pointing this out.

Would it suffice to get the userns as: =E2=80=9Csk_user_ns(sk)=E2=80=9D?

Or would it be better to pass struct netlink_callback *cb from =
unix_diag_dump() to sk_diag_dump() to sk_diag_fill(), then to the new =
function to add the UID?

cheers,
-Felipe Gasper=
