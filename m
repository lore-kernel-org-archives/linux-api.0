From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Tue, 27 Oct 2015 10:12:06 +0100
Message-ID: <1979544.kURdYDnObN@tauon.atsec.com>
References: <1831785.BBs8Hj3CxY@myon.chronox.de> <BDD3AC1F-26D5-41D2-863B-CF8C7BF5FFEE@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BDD3AC1F-26D5-41D2-863B-CF8C7BF5FFEE-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Dienstag, 27. Oktober 2015, 13:54:30 schrieb Marcel Holtmann:

Hi Marcel,

>Hi Stephan,
>
>> This patch set adds the AF_ALG user space API to externalize the
>> asymmetric cipher API recently added to the kernel crypto API.
>> 
>> The patch set is tested with the user space library of libkcapi [1].
>> Use [1] test/test.sh for a full test run. The test covers the
>> 
>> following scenarios:
>> 	* sendmsg of one IOVEC
>> 	
>> 	* sendmsg of 16 IOVECs with non-linear buffer
>> 	
>> 	* vmsplice of one IOVEC
>> 	
>> 	* vmsplice of 15 IOVECs with non-linear buffer
>> 	
>> 	* invoking multiple separate cipher operations with one
>> 	
>> 	  open cipher handle
>> 	
>> 	* encryption with private key (using vector from testmgr.h)
>> 	
>> 	* encryption with public key (using vector from testmgr.h)
>> 	
>> 	* decryption with private key (using vector from testmgr.h)
>
>after having discussions with David Howells and David Woodhouse, I don't
>think we should expose akcipher via AF_ALG at all. I think the akcipher
>operations for sign/verify/encrypt/decrypt should operate on asymmetric keys
>in the first place. With akcipher you are pretty much bound to public and
>private keys and the key is the important part and not the akcipher itself.
>Especially since we want to support private keys in hardware (like TPM for
>example).
>
>It seems more appropriate to use keyctl to derive the symmetric session key

Are you saying that you consider importing parts of TLS into the kernel? 
Considering the use case where akcipher would be used to speed up network 
protocols, I would imply that your comment refers to importing parts of that 
network protocol into the kernel.

The key derivation that you mention here would be: RSA-based key exchange plus 
the TLS KDF. Do we really want to load that into the kernel given that TLS is 
one protocol and there are many others?

>from your asymmetric key. And then use the symmetric session key id with
>skcipher via AF_ALG. Especially once symmetric key type has been introduced
>this seems to be trivial then.
>
>I am not really in favor of having two userspace facing APIs for asymmetric
>cipher usage. And we need to have an API that is capable to work with
>hardware keys.
>
>Regards
>
>Marcel
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
