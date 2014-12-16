From: "Peter Huewe" <PeterHuewe@gmx.de>
Subject: Aw: Re: [PATCH v10 0/8] TPM 2.0 support
Date: Tue, 16 Dec 2014 22:19:26 +0100
Message-ID: <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>,
 <20141215201757.GA27923@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141215201757.GA27923@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh@joshtriplett.org, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

> So, what do you think? Are we now settled with this?

Meh...
It does not recognize my tpm20 with force=3D1 :( :( :(
Probably since I don't have a machine with bios integration -> no tpm s=
tartup,
and your startup is returned with RC_SIZE :(



=C2=A0rmmod tpm; modprobe tpm_tis force=3D1 ; dmesg=20
modprobe: ERROR: could not insert 'tpm_tis': No such device
[   77.744050] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
[   77.816049] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   77.888043] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   77.960043] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   77.960057] genirq: Flags mismatch irq 6. 00000080 (tpm0) vs. 000000=
00 (floppy)
[   77.960067] tpm_tis tpm_tis: Unable to request irq: 6 for probe
[   77.960073] genirq: Flags mismatch irq 7. 00000080 (tpm0) vs. 000000=
00 (parport0)
[   77.960077] tpm_tis tpm_tis: Unable to request irq: 7 for probe
[   77.960082] genirq: Flags mismatch irq 8. 00000080 (tpm0) vs. 000000=
00 (rtc0)
[   77.960087] tpm_tis tpm_tis: Unable to request irq: 8 for probe
[   78.032041] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   78.104043] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   78.176041] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   78.248041] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   78.320041] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   78.392040] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   78.464041] tpm_tis tpm_tis: A TPM error (256) occurred attempting t=
o generate an interrupt
[   78.524041] tpm_tis tpm_tis: A TPM error (256) occurred continue sel=
ftest
[   78.524048] tpm_tis tpm_tis: Firmware has not started TPM
[   78.596041] tpm_tis tpm_tis: A TPM error (149) occurred attempting t=
o start the TPM
[   78.596048] tpm_tis tpm_tis: TPM self test failed


;(
Peter
