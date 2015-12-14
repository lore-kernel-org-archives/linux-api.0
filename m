From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Mon, 14 Dec 2015 10:06:21 -0800
Message-ID: <566F051D.4080408@intel.com>
References: <1831785.BBs8Hj3CxY@myon.chronox.de>
 <BDD3AC1F-26D5-41D2-863B-CF8C7BF5FFEE@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BDD3AC1F-26D5-41D2-863B-CF8C7BF5FFEE-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,
On 10/26/2015 09:54 PM, Marcel Holtmann wrote:
> Hi Stephan,
> 
>> This patch set adds the AF_ALG user space API to externalize the
>> asymmetric cipher API recently added to the kernel crypto API.
>>
>> The patch set is tested with the user space library of libkcapi [1].
>> Use [1] test/test.sh for a full test run. The test covers the
>> following scenarios:
>>
>> 	* sendmsg of one IOVEC
>>
>> 	* sendmsg of 16 IOVECs with non-linear buffer
>>
>> 	* vmsplice of one IOVEC
>>
>> 	* vmsplice of 15 IOVECs with non-linear buffer
>>
>> 	* invoking multiple separate cipher operations with one
>> 	  open cipher handle
>>
>> 	* encryption with private key (using vector from testmgr.h)
>>
>> 	* encryption with public key (using vector from testmgr.h)
>>
>> 	* decryption with private key (using vector from testmgr.h)
> 
> after having discussions with David Howells and David Woodhouse, I don't think we should expose akcipher via AF_ALG at all. I think the akcipher operations for sign/verify/encrypt/decrypt should operate on asymmetric keys in the first place. With akcipher you are pretty much bound to public and private keys and the key is the important part and not the akcipher itself. Especially since we want to support private keys in hardware (like TPM for example).
> 
> It seems more appropriate to use keyctl to derive the symmetric session key from your asymmetric key. And then use the symmetric session key id with skcipher via AF_ALG. Especially once symmetric key type has been introduced this seems to be trivial then.
> 
> I am not really in favor of having two userspace facing APIs for asymmetric cipher usage. And we need to have an API that is capable to work with hardware keys.

If we would have something like this:

diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index f2acd2f..02e6162 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -34,9 +34,12 @@ struct af_alg_iv {
 #define ALG_SET_OP			3
 #define ALG_SET_AEAD_ASSOCLEN		4
 #define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_PUBKEY			6
+#define ALG_SET_PUBKEY_ID		7

in case of ALG_SET_PUBKEY the key will be provided by user space
and in case of ALG_SET_PUBKEY_ID the PF_ALG layer will retrieve the
key from the keyring using the ID provided form user space.
Will this be ok with you Marcel and David?
Thanks,

-- 
TS
