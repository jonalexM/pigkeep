import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Box,
  TextField,
} from '@mui/material';
import { PigQR } from './PigQR';
import { useRef, useState } from 'react';
import html2canvas from 'html2canvas';
import jsPDF from 'jspdf';

export const AllPigsQRModal = ({
  pigs,
  isOpen,
  onClose,
}: {
  pigs: any[];
  isOpen: boolean;
  onClose?: () => void;
}) => {
  const printRef = useRef<any>(null);
  const [widthPX, setWidthPX] = useState(192);
  const [heightPX, setHeightPX] = useState(144);
  const [fontPX, setFontPX] = useState(45);

  const handlePrint = async () => {
    if (printRef.current) {
      const element = printRef.current;
      const canvas = await html2canvas(element);
      const imgData = canvas.toDataURL('image/png');
      const pdf = new jsPDF('p', 'mm', 'a4');
      const pdfWidth = pdf.internal.pageSize.getWidth();
      const pdfHeight = pdf.internal.pageSize.getHeight();
      const imgWidth = pdfWidth;
      const imgHeight = (canvas.height * imgWidth) / canvas.width;

      pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);

      pdf.save('pigs_qr_codes.pdf');
    } else {
      console.error('printRef is not assigned');
    }
  };

  return (
    <Dialog open={isOpen} onClose={onClose} fullWidth maxWidth="xl">
      <DialogTitle>VIEW ALL ALIVE PIGS QR</DialogTitle>
      <DialogContent>
        <style>
          {`
            @media print {
              body * {
                visibility: hidden;
              }
              .print_content, .print_content * {
                visibility: visible;
              }
              .print_content {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
              }
            }
          `}
        </style>
        <Box p={3}>
          <Box p={3} display="flex" gap={2}>
            <TextField
              label="QR Width (px)"
              size="small"
              value={widthPX}
              type="number"
              onChange={(v) => setWidthPX(parseInt(v.target.value))}
            />
            <TextField
              label="QR Height (px)"
              size="small"
              value={heightPX}
              type="number"
              onChange={(v) => setHeightPX(parseInt(v.target.value))}
            />
            <TextField
              label="Font Size"
              size="small"
              value={fontPX}
              type="number"
              onChange={(v) => setFontPX(parseInt(v.target.value))}
            />
          </Box>
          <Box
            className="print_content"
            ref={printRef}
            display="flex"
            flexWrap="wrap"
            justifyContent="space-evenly"
            gap={2}
          >
            {pigs
              .filter((pig: any) => pig.status === 'alive')
              .sort((a, b) => a.pigNumber.localeCompare(b.pigNumber))
              .map((pig) => (
                <Box key={pig.uuid}>
                  <PigQR
                    label={pig.pigNumber.replace('P-', '')}
                    qrValue={'pigkeep:' + pig.pigNumber + ':' + pig.uuid}
                    widthPX={widthPX}
                    heightPX={heightPX}
                    fontPX={fontPX}
                  />
                </Box>
              ))}
          </Box>
        </Box>
      </DialogContent>
      <DialogActions>
        <Button onClick={onClose} color="primary">
          Close
        </Button>
        <Button onClick={() => handlePrint()} color="primary">
          Download
        </Button>
      </DialogActions>
    </Dialog>
  );
};
