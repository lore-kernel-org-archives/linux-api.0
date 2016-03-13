From: Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: Re: [PATCH v7 08/10] tpm: Proxy driver for supporting multiple
 emulated TPMs
Date: Sat, 12 Mar 2016 20:52:28 -0500
Message-ID: <56E4C7DC.6010608@linux.vnet.ibm.com>
References: <1457751065-11507-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457751065-11507-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160312185154.GA12412@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160312185154.GA12412@intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/12/2016 01:51 PM, Jarkko Sakkinen wrote:
> On Fri, Mar 11, 2016 at 09:51:03PM -0500, Stefan Berger wrote:
>> This patch implements a proxy driver for supporting multiple emulated TPMs
>> in a system.
>>
>> The driver implements a device /dev/vtpmx that is used to created
>> a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
>> is accessed using a file descriptor returned by an ioctl.
>> The device /dev/tpmX is the usual TPM device created by the core TPM
>> driver. Applications or kernel subsystems can send TPM commands to it
>> and the corresponding server-side file descriptor receives these
>> commands and delivers them to an emulated TPM.
> With my test script [1] running on QEMU and TPM 2.0 simulator running on the
> host side I get this:
>
> $ python tpm2-simulator-vtpm --host=10.0.2.2
> cmd
> 80 01 00 00 00 0c 00 00 01 44 00 00
> rsp
> 80 01 00 00 00 0a 00 00 00 00
> Traceback (most recent call last):
>    File "tpm2-simulator-vtpm", line 85, in <module>
>      main()
>    File "tpm2-simulator-vtpm", line 80, in main
>      resp = client.send_cmd(stream)
>    File "/home/tpmdd/tpm2-scripts/tpm2.py", line 454, in send_cmd
>      rsp = self.simulator.send_cmd(cmd)
>    File "/home/tpmdd/tpm2-scripts/tpm2.py", line 436, in send_cmd
>      raise SimulatorError("Empty response")
> tpm2.SimulatorError: Empty response
>
> However, the process does not exit before the read call expires:
>
> $ python tpm2-list-handles
> Traceback (most recent call last):
>    File "tpm2-list-handles", line 61, in <module>
>      main()
>    File "tpm2-list-handles", line 51, in main
>      handles += client.get_cap(tpm2.TPM2_CAP_HANDLES, tpm2.HR_LOADED_SESSION)
>    File "/home/tpmdd/tpm2-scripts/tpm2.py", line 782, in get_cap
>      next_handles, more_data = self.__get_cap_cnt(cap, pt, 1)
>    File "/home/tpmdd/tpm2-scripts/tpm2.py", line 766, in __get_cap_cnt
>      rsp = self.send_cmd(cmd)[10:]
>    File "/home/tpmdd/tpm2-scripts/tpm2.py", line 458, in send_cmd
>      rsp = f.read()
> IOError: [Errno 62] Timer expired
>
> The server side stays stuck unti this happens.

This fix should solve the problem:

diff --git a/drivers/char/tpm/tpm_vtpm_proxy.c 
b/drivers/char/tpm/tpm_vtpm_proxy.c
index d73944e..01e5070 100644
--- a/drivers/char/tpm/tpm_vtpm_proxy.c
+++ b/drivers/char/tpm/tpm_vtpm_proxy.c
@@ -456,10 +456,10 @@ err_delete_proxy_dev:
   */
  static void vtpm_proxy_delete_device(struct proxy_dev *proxy_dev)
  {
-       tpm_chip_unregister(proxy_dev->chip);
-
         vtpm_proxy_fops_undo_open(proxy_dev);

+      tpm_chip_unregister(proxy_dev->chip);
+
         vtpm_proxy_delete_proxy_dev(proxy_dev);
  }


Can you let me know whether this gets it working for you? I'd prepare a v9.

    Stefan

