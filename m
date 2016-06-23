From: Denis Kenzior <denkenz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 3/6] crypto: AF_ALG -- add asymmetric cipher interface
Date: Thu, 23 Jun 2016 10:22:27 -0500
Message-ID: <576BFEB3.5080009@gmail.com>
References: <20160515041645.15888.94903.stgit@tstruk-mobl1>
 <dbcb97e0-35c0-7e6e-9351-d90a0d945bab@intel.com>
 <alpine.OSX.2.20.1606221515040.16377@mjmartin-mac01.local>
 <3250613.UAo0YkFYZb@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3250613.UAo0YkFYZb-gNvIQDDl/k7Ia13z/PHSgg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>, Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Stephan,

 >>
>> This brings me to another proposal for read buffer sizing: AF_ALG ak=
cipher
>> can guarantee that partial reads (where the read buffer is shorter t=
han
>> the output of the crypto op) will work using the same semantics as
>> SOCK_DGRAM/SOCK_SEQPACKET. With those sockets, as much data as will =
fit is
>> copied in to the read buffer and the remainder is discarded.
>>
>> I realize there's a performance and memory tradeoff, since the crypt=
o
>> algorithm needs a sufficiently large output buffer that would have t=
o be
>> created by AF_ALG akcipher. The user could manage that tradeoff by
>> providing a larger buffer (typically key_size?) if it wants to avoid
>> allocating and copying intermediate buffers inside the kernel.
>
> How shall the user know that something got truncated or that the kern=
el
> created memory?
>

To the former point, recall the signature of recv:
ssize_t recv(int sockfd, void *buf, size_t len, int flags);

Traditionally, userspace apps can know that the buffer provided to recv=
=20
was too small in two ways:

The return value from recv / recvmsg was >=3D len.

In the case of recvmsg, the MSG_TRUNC flag is set.

To quote man recv:

"All  three calls return the length of the message on successful comple=
=E2=80=90
tion.  If a message is too long to fit in the supplied  buffer,  excess
bytes  may  be discarded depending on the type of socket the message is
received from."

and

"MSG_TRUNC (since Linux 2.2)

	For   raw   (AF_PACKET),   Internet   datagram   (since    Linux
	2.4.27/2.6.8),  netlink  (since Linux 2.6.22), and UNIX datagram
	(since Linux 3.4) sockets: return the real length of the  packet
	or datagram, even when it was longer than the passed buffer.
"

Regards,
-Denis
