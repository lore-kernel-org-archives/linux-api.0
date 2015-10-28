From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Wed, 28 Oct 2015 11:12:05 +0100
Message-ID: <3674514.AfR75N8aU6@tauon.atsec.com>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <4777180.cceLVNSOUa@myon.chronox.de> <F0D283A6-37C8-47EC-9DE0-998B8A59F138@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F0D283A6-37C8-47EC-9DE0-998B8A59F138-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 28. Oktober 2015, 11:56:59 schrieb Marcel Holtmann:

Hi Marcel,
>> 
>> With all due respect, I would object here. When we say yes to TLS (even if
>> it is parts of TLS up to the point where the KDF happens), we invite all
>> higher level crypto implementations: IKE, SNMP, SSH -- I would not want to
>> go down that path that started by simply supporting accelerated asymmetric
>> ciphers.
>Reality is that TLS in the kernel is happening. Reality is also that we do

This is simply wrong IMHO for anything beyond the key handling. But that is 
not the topic here, I guess.


Ciao
Stephan
